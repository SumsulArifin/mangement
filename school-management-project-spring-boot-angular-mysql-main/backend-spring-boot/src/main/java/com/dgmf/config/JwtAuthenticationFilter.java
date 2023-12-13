package com.dgmf.config;

import com.dgmf.repository.TokenRepository;
import com.dgmf.service.JwtService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/*
1.	JwtAuthenticationFilter
When a Client sends a Request, the first thing that will be executed is
the « JwtAuthenticationFilter ».
The « JwtAuthenticationFilter » has the role to validate and check everything
regarding the JWT Token that the Client owned or not.
"OncePerRequestFilter" ==> The « JwtAuthenticationFilter » will be activated
every time the Application gets a Request
*/
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private final JwtService jwtService;
    private final UserDetailsService userDetailsService;
    private final TokenRepository tokenRepository;

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            // Chain of Responsibility Design Pattern
            // Contains the list of the Filters
            @NonNull FilterChain filterChain
        ) throws ServletException, IOException {
        // To extract the jwtToken
        final String jwtToken;
        // To extract the Username
        final String username;

        // 2. The « JwtAuthenticationFilter » checks if the Client
        // has a JWT Token or not, and extracts it if it is present.
        jwtToken = getTokenFromRequest(request);

        // 3. If the JWT Token is missing (null) ==> 403 response to
        // the Client ==> "HTTP 403 - Missing JWT Token"
        if(jwtToken == null) {
            // Passing the "Request" and the "Response" to the
            // next Filter
            filterChain.doFilter(request, response);

            System.out.println("Stack Trace - JwtAuthenticationFilter - " +
                    "doFilterInternal() 'jwtToken == null'");

            return;
        }

        /* 4. The JWT Token is present ==> Start of the Validation Process.
                - 4.1 If "username/email" does not exist ==> 403 response
                to the Client ==> "HTTP 403 - User does not exist"
                - 4.2 Retrieval of "username/email" (JWT subject) based on
                the JWT Token
        */
        // Here, The "Username" has been retrieved
        username = jwtService.getUsernameFromToken(jwtToken); // 4.2

        /* 5. If getting User "username" from the DB is ok and
        the User is not authenticated yet. Because if the User is
        already authenticated, we don't need to perform all the checks
        and updating the "SecurityContextHolder". We just need, in this
        case, to pass the Request to the "DispatcherServlet" */
        if(username != null && SecurityContextHolder.getContext()
                        .getAuthentication() == null) {
            /* 6. Internal call using the "UserDetailsService" to try to
            fetch User information from the DB, based on the
            User "email/username" sets as a Claim or Token subject. */
            UserDetails userDetails = userDetailsService
                    .loadUserByUsername(username);

            // Checking if the JWT Token is not expired or revoked inside the DB
            var isTokenValidIntoTheDB = tokenRepository
                    .findByToken(jwtToken)
                    .map(token -> !token.isExpired() && !token.isRevoked())
                    .orElse(false);

            /* 7. Using the "UserDetailsService", start of the
            validation Process of the JWT Token for the specific User
                - 7.1 If the JWT Token is not valid (is expired, is not
                for the specific User, etc ...) ==> 403 response to
                the Client ==> "HTTP 403 - Invalid JWT Token"
            */
            // Checks if the JWT token is valid or not from the Request and
            // into the DB
            if(jwtService.isTokenValid(jwtToken, userDetails)
                    && isTokenValidIntoTheDB) {
                // 7.2 The JWT Token is valid ==> Setting up a Connected User
                // Instantiation of a "UsernamePasswordAuthenticationToken"
                UsernamePasswordAuthenticationToken authToken =
                        new UsernamePasswordAuthenticationToken(
                                userDetails,
                                null,
                                userDetails.getAuthorities());

                // Add more details from the request
                authToken.setDetails(
                        new WebAuthenticationDetailsSource()
                                .buildDetails(request));

                // 8. Update of the "SecurityContextHolder" ==> For the
                // rest of the other Filters, the User will be
                // considered authenticated
                SecurityContextHolder.getContext().setAuthentication(authToken);

                System.out.println("Stack Trace - JwtAuthenticationFilter " +
                        "- doFilterInternal() 'username != null' && " +
                        "'getAuthentication() == null' && 'Token is Valid'");
            }
        }

        // 9. The Request is sent to the next Filter
        filterChain.doFilter(request, response);

        System.out.println("Stack Trace - JwtAuthenticationFilter - doFilterInternal() \n'username != null' && 'getAuthentication() != null'");
    }

    // 2.
    private String getTokenFromRequest(HttpServletRequest request) {
        // Retrieval of the "Authorization" Header
        final String authHeader = request
                .getHeader(HttpHeaders.AUTHORIZATION);

        // Checking if the "Authorization" Header contains the
        // "Bearer Token" (JWT Token)
        if(StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
            System.out.println("Stack Trace - JwtAuthenticationFilter " +
                    "- getTokenFromRequest() Returns a 'Bearer Token' " +
                    "(JWT Token)");

            // If yes, returns "Bearer Token"
            return authHeader.substring(7);
        }

        System.out.println("Stack Trace - JwtAuthenticationFilter " +
                "- getTokenFromRequest() 'Bearer Token' (JWT Token) == " +
                "'null'");

        // Return "null" if the "Bearer Token" is missing in
        // the "Authorization" Header
        return null;
    }
}

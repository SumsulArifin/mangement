package com.example.hospitalplanner;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.data.jpa.repository.Query;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@SpringBootApplication
public class HospitalPlannerApplication  {

	public static void main(String[] args) {
		SpringApplication.run(HospitalPlannerApplication.class, args);
	}
//
//	extends SpringBootServletInitializer
//	@Override
//	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
//		return builder.sources(HospitalPlannerApplication.class);
//	}
//	@Bean
//	public CorsConfigurationSource corsConfigurationSource() {
//		CorsConfiguration configuration = new CorsConfiguration();
//		configuration.addAllowedOriginPattern("*");
//		configuration.addAllowedMethod("*");
//		configuration.addAllowedHeader("*");
//		configuration.setAllowCredentials(true);
//		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
//		source.registerCorsConfiguration("/**", configuration);
//		return source;
//	}
}

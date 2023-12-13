package com.dgmf.entity;

import com.dgmf.entity.enums.TokenType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data @NoArgsConstructor @AllArgsConstructor @Builder
@Table(
        name = "tbl_token",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "token_unique", // Entity Attribute name
                        columnNames = "token" // DB Column name
                )
        }
)
public class Token {
    @Id
    @GeneratedValue(
            strategy = GenerationType.SEQUENCE,
            generator = "token_generator"
    )
    @SequenceGenerator(
            name = "token_generator",
            sequenceName = "token_sequence_name",
            allocationSize = 1
    )
    private Long id;
    @Column(name = "token")
    private String token;
    @Enumerated(EnumType.STRING)
    private TokenType tokenType;
    private boolean expired;
    private boolean revoked;
    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;
}

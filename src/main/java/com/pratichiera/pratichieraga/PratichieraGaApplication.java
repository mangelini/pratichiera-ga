package com.pratichiera.pratichieraga;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class PratichieraGaApplication {

    public static void main(String[] args) {
        SpringApplication.run(PratichieraGaApplication.class, args);
    }

}

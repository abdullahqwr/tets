package com.example.app.web;

import java.time.OffsetDateTime;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

    @Value("${application.version:1.0.0}")
    private String version = "1.0.0";

    @GetMapping("/health")
    public Map<String, Object> getHealth() {
        return Map.of(
            "status", "UP",
            "version", version,
            "timestamp", OffsetDateTime.now().toString()
        );
    }

    void setVersion(String version) {
        this.version = version;
    }
}

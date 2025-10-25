package com.example.app.web;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Map;

import org.junit.jupiter.api.Test;

class HealthControllerTest {

    private final HealthController controller = new HealthController();

    @Test
    void healthHasStatus() {
        controller.setVersion("test");
        Map<String, Object> response = controller.getHealth();
        assertThat(response.get("status")).isEqualTo("UP");
        assertThat(response.get("version")).isEqualTo("test");
    }
}

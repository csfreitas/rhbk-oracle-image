FROM registry.redhat.io/rhbk/keycloak-rhel9:26.0 AS builder

# Copiando os Oracle JDBC Drivers
#COPY --chown=keycloak:keycloak --chmod=644 ojdbc/ojdbc17.jar /opt/keycloak/providers/ojdbc17.jar
#ADD --chown=keycloak:keycloak --chmod=644 https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc11/23.5.0.24.07/ojdbc11-23.5.0.24.07.jar /opt/keycloak/providers/ojdbc11.jar
#ADD --chown=keycloak:keycloak --chmod=644 https://repo1.maven.org/maven2/com/oracle/database/nls/orai18n/23.5.0.24.07/orai18n-23.5.0.24.07.jar /opt/keycloak/providers/orai18n.jar
# Copiando a SPI Metrics
COPY --chown=keycloak:keycloak --chmod=644 spi/keycloak-metrics-spi-7.0.0.jar /opt/keycloak/providers/keycloak-metrics-spi-7.0.0.jargit

ENV KC_HEALTH_ENABLED=true \
    KC_METRICS_ENABLED=true \
    TZ='America/Sao_Paulo' \
    KC_DB=postgres \
    KC_FEATURES="opentelemetry"

RUN /opt/keycloak/bin/kc.sh build

FROM registry.redhat.io/rhbk/keycloak-rhel9:26.0

COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]
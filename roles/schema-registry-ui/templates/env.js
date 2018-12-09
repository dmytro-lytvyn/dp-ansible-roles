var clusters = [
  {
    NAME: "prod",
    SCHEMA_REGISTRY: "http://{{ schema_registry_domain_name }}:{{ schema_registry_listener_port }}", // Schema Registry service URL (i.e. http://localhost:8081)
    COLOR: "#141414", // optional
    allowGlobalConfigChanges: true, // optional
    allowSchemaDeletion: true,  // Supported for Schema Registry version >= 3.3.0 
    allowTransitiveCompatibilities: true        // if using a Schema Registry release >= 3.1.1 uncomment this line
  }
];

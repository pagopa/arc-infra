[
  {
    "apiName" : "root",
    "appName" : "arc",
    "url" : "https://${api_dot_env_name}.cittadini.pagopa.it/",
    "type" : "apim",
    "checkCertificate" : true,
    "method" : "GET",
    "expectedCodes" : ["200"],
    "tags" : {
      "description" : "p4pa ${env_name} context root"
    },
    "durationLimit" : 10000,
    "alertConfiguration" : {
      "enabled" : ${alert_enabled}
    }
  },
  {
    "apiName" : "root",
    "appName" : "arc",
    "url" : "https://${appgw_public_ip}/",
    "type" : "appgw",
    "checkCertificate" : true,
    "method" : "GET",
    "expectedCodes" : ["200"],
    "headers": {
      "Host": "${api_dot_env_name}.cittadini.pagopa.it"
    },
    "tags" : {
      "description" : "arc ${env_name} context root"
    },
    "durationLimit" : 10000,
    "alertConfiguration" : {
      "enabled" : ${alert_enabled}
    }
  }
]

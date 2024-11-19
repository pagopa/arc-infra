{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 9,
      "content": {
        "version": "KqlParameterItem/1.0",
        "parameters": [
          {
            "id": "75b945d9-1f77-40e6-a8f6-2356759b8c3b",
            "version": "KqlParameterItem/1.0",
            "name": "timeRangeOverall",
            "type": 4,
            "isRequired": true,
            "typeSettings": {
              "selectableValues": [
                {
                  "durationMs": 300000
                },
                {
                  "durationMs": 900000
                },
                {
                  "durationMs": 1800000
                },
                {
                  "durationMs": 86400000
                }
              ],
              "allowCustom": true
            },
            "timeContext": {
              "durationMs": 86400000
            },
            "value": {
              "durationMs": 86400000
            }
          },
          {
            "id": "4a7b6e18-8b58-4227-86a9-c6ac65cd7bb8",
            "version": "KqlParameterItem/1.0",
            "name": "timeSpan",
            "type": 10,
            "isRequired": true,
            "typeSettings": {
              "additionalResourceOptions": [],
              "showDefault": false
            },
            "jsonData": "[\r\n    {\"label\": \"1s\", \"value\": 1000, \"selected\": false},\r\n    {\"label\": \"5s\", \"value\": 5000, \"selected\": false},\r\n    {\"label\": \"10s\", \"value\": 10000, \"selected\": false},\r\n    {\"label\": \"30s\", \"value\": 30000, \"selected\": false},\r\n    {\"label\": \"1m\", \"value\": 60000, \"selected\": true},\r\n    {\"label\": \"2m\", \"value\": 120000, \"selected\": false},\r\n    {\"label\": \"10m\", \"value\": 600000, \"selected\": false},\r\n    {\"label\": \"30m\", \"value\": 3600000, \"selected\": false}\r\n]",
            "timeContext": {
              "durationMs": 86400000
            }
          }
        ],
        "style": "pills",
        "queryType": 0,
        "resourceType": "microsoft.insights/components"
      },
      "name": "parameters - 2"
    },
    {
      "type": 12,
      "content": {
        "version": "NotebookGroup/1.0",
        "groupType": "editable",
        "items": [
          {
            "type": 11,
            "content": {
              "version": "LinkItem/1.0",
              "style": "tabs",
              "links": [
                {
                  "id": "af5a3000-400d-4b80-92a2-7454bfefbdaa",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "OPEX - OVERALL",
                  "subTarget": "all",
                  "style": "link",
                  "linkIsContextBlade": true
                },
                {
                  "id": "5a3e244e-a412-4f57-912f-0e0cc4e4abd1",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "RESOURCE METRICS",
                  "subTarget": "resourceMetrics",
                  "style": "link"
                },
                {
                  "id": "71a6e41d-5cb9-4ee1-b71b-d3011168e8e9",
                  "cellValue": "selectedTab",
                  "linkTarget": "parameter",
                  "linkLabel": "SERVIZI ESTERNI",
                  "subTarget": "externalService",
                  "style": "link"
                }
              ]
            },
            "name": "links - 0"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "items": [
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\nlet data = requests\n    | where timestamp between (startTime .. endTime) and operation_Name startswith \"arc\";\nlet operationData = data;\nlet totalOperationCount = operationData\n    | summarize Total = count() by operation_Name;\noperationData\n| join kind=inner totalOperationCount on operation_Name\n| summarize\n    Count = count(),\n    Users = dcount(tostring(customDimensions[\"Request-X-Forwarded-For\"])),\n    AvgResponseTime = round(avg(duration), 2)\n    by operation_Name, resultCode, Total\n| project\n    ['Request Name'] = operation_Name,\n    ['Result Code'] = resultCode,\n    ['Total Response'] = Count,\n    ['Rate %'] = (Count * 100) / Total,\n    ['Users Affected'] = Users,\n    ['Avg Response Time (ms)'] = AvgResponseTime\n| sort by ['Total Response'] desc\n\n",
                    "size": 0,
                    "showAnalytics": true,
                    "timeContextFromParameter": "timeRangeOverall",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ],
                    "gridSettings": {
                      "formatters": [
                        {
                          "columnMatch": "Result Code",
                          "formatter": 18,
                          "formatOptions": {
                            "thresholdsOptions": "icons",
                            "thresholdsGrid": [
                              {
                                "operator": "==",
                                "thresholdValue": "429",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "==",
                                "thresholdValue": "404",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "startsWith",
                                "thresholdValue": "5",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "startsWith",
                                "thresholdValue": "2",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "Default",
                                "thresholdValue": null,
                                "representation": "warning",
                                "text": "{0}{1}"
                              }
                            ],
                            "customColumnWidthSetting": "20ch"
                          }
                        },
                        {
                          "columnMatch": "Total Response",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 1,
                            "palette": "blue"
                          }
                        },
                        {
                          "columnMatch": "Rate %",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 0,
                            "max": 100,
                            "palette": "yellowGreenBlue"
                          },
                          "numberFormat": {
                            "unit": 1,
                            "options": {
                              "style": "decimal",
                              "useGrouping": false
                            }
                          }
                        },
                        {
                          "columnMatch": "Users Affected",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 0,
                            "palette": "blueDark"
                          }
                        },
                        {
                          "columnMatch": "Group",
                          "formatter": 1
                        },
                        {
                          "columnMatch": "Failed with Result Code",
                          "formatter": 18,
                          "formatOptions": {
                            "thresholdsOptions": "icons",
                            "thresholdsGrid": [
                              {
                                "operator": "startsWith",
                                "thresholdValue": "5",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "==",
                                "thresholdValue": "429",
                                "representation": "4",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "startsWith",
                                "thresholdValue": "2",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "==",
                                "thresholdValue": "404",
                                "representation": "success",
                                "text": "{0}{1}"
                              },
                              {
                                "operator": "Default",
                                "thresholdValue": null,
                                "representation": "2",
                                "text": "{0}{1}"
                              }
                            ],
                            "compositeBarSettings": {
                              "labelText": "",
                              "columnSettings": [
                                {
                                  "columnName": "Failed with Result Code",
                                  "color": "blue"
                                }
                              ]
                            }
                          },
                          "numberFormat": {
                            "unit": 0,
                            "options": {
                              "style": "decimal"
                            }
                          }
                        },
                        {
                          "columnMatch": "Total Failures",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 1,
                            "palette": "blue"
                          }
                        },
                        {
                          "columnMatch": "Failure rate %",
                          "formatter": 8,
                          "formatOptions": {
                            "min": 0,
                            "max": 100,
                            "palette": "redGreen"
                          }
                        }
                      ],
                      "sortBy": [
                        {
                          "itemKey": "$gen_heatmap_Total Response_2",
                          "sortOrder": 2
                        }
                      ]
                    },
                    "sortBy": [
                      {
                        "itemKey": "$gen_heatmap_Total Response_2",
                        "sortOrder": 2
                      }
                    ],
                    "tileSettings": {
                      "showBorder": false,
                      "titleContent": {
                        "columnMatch": "Request Name",
                        "formatter": 1
                      },
                      "leftContent": {
                        "columnMatch": "Total Failures",
                        "formatter": 12,
                        "formatOptions": {
                          "palette": "auto"
                        },
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      }
                    },
                    "graphSettings": {
                      "type": 0,
                      "topContent": {
                        "columnMatch": "Request Name",
                        "formatter": 1
                      },
                      "leftContent": {
                        "columnMatch": "Failed with Result Code"
                      },
                      "centerContent": {
                        "columnMatch": "Total Failures",
                        "formatter": 1,
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      },
                      "rightContent": {
                        "columnMatch": "Failure rate %"
                      },
                      "bottomContent": {
                        "columnMatch": "Users Affected"
                      },
                      "nodeIdField": "Request Name",
                      "sourceIdField": "Failed with Result Code",
                      "targetIdField": "Total Failures",
                      "graphOrientation": 3,
                      "showOrientationToggles": false,
                      "nodeSize": null,
                      "staticNodeSize": 100,
                      "colorSettings": null,
                      "hivesMargin": 5
                    },
                    "chartSettings": {
                      "showLegend": true,
                      "showDataPoints": true
                    },
                    "mapSettings": {
                      "locInfo": "LatLong",
                      "sizeSettings": "Total Failures",
                      "sizeAggregation": "Sum",
                      "legendMetric": "Total Failures",
                      "legendAggregation": "Sum",
                      "itemColorSettings": {
                        "type": "heatmap",
                        "colorAggregation": "Sum",
                        "nodeColorField": "Total Failures",
                        "heatmapPalette": "greenRed"
                      }
                    }
                  },
                  "name": "query - 14"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\n\nlet dataset = requests\n    // additional filters can be applied here\n    | where timestamp between (startTime .. endTime) and operation_Name startswith \"arc\"\n;\ndataset\n| summarize percentile_95=percentile(duration, 95) by bin(timestamp, interval)\n| project timestamp, percentile_95, watermark=1000\n| render timechart",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Requests duration p95",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ],
                    "visualization": "timechart"
                  },
                  "customWidth": "50",
                  "name": "Requests duration p95"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\nlet endTime = {timeRangeOverall:end};\nlet interval = totimespan({timeSpan:label});\n\nlet tot = requests\n    | where timestamp between (startTime .. endTime) \n    | where operation_Name has 'cittadini'\n    | summarize tot = todouble(count()) by bin(timestamp, interval);\nlet errors = requests\n    | where operation_Name has 'cittadini'\n    | where strcmp(resultCode, \"412\") > 0 \n    | summarize not_ok = count() by bin(timestamp, interval);\ntot\n| join kind=leftouter errors on timestamp\n| project timestamp, availability = (tot - coalesce(not_ok, 0)) / tot, watermark=0.99",
                    "size": 0,
                    "aggregation": 3,
                    "showAnalytics": true,
                    "title": "Availability @ AppGateway",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ],
                    "visualization": "timechart",
                    "chartSettings": {
                      "ySettings": {
                        "min": 0,
                        "max": 1
                      }
                    }
                  },
                  "customWidth": "50",
                  "name": "Availability @ AppGateway"
                },
                {
                  "type": 3,
                  "content": {
                    "version": "KqlItem/1.0",
                    "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\nlet data = requests\r\n| where timestamp between (startTime .. endTime) and operation_Name has \"arc\";\r\nlet unknowApi = data\r\n| join kind=inner exceptions on operation_Id\r\n| where type has \"OperationNotFound\";\r\nlet totalRequestCount = toscalar (data\r\n| count);\r\nlet joinedUnknowApi = unknowApi\r\n| summarize\r\n        Count = count(),\r\n        Users = dcount(tostring(customDimensions[\"Request-X-Forwarded-For\"]))\r\n        by operation_Name, resultCode, type\r\n| project \r\n        ['Request Name'] = operation_Name,\r\n        ['Result Code'] = resultCode,\r\n        ['Total Response'] = Count,\r\n        ['Rate (% of total requests)'] = (Count * 100) / totalRequestCount,\r\n        ['Users Affected'] = Users,\r\n        ['Type'] = type;\r\nunion joinedUnknowApi",
                    "size": 1,
                    "showAnalytics": true,
                    "title": "Operation Not Found",
                    "timeContextFromParameter": "timeRangeOverall",
                    "queryType": 0,
                    "resourceType": "microsoft.insights/components",
                    "crossComponentResources": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ]
                  },
                  "conditionalVisibility": {
                    "parameterName": "selectedTab",
                    "comparison": "isEqualTo",
                    "value": "all"
                  },
                  "name": "Operation Not Found",
                  "styleSettings": {
                    "showBorder": true
                  }
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "all"
            },
            "name": "all"
          },
          {
            "type": 9,
            "content": {
              "version": "KqlParameterItem/1.0",
              "parameters": [
                {
                  "id": "2c27e0f6-1f79-4352-a6cb-2194f39415b8",
                  "version": "KqlParameterItem/1.0",
                  "name": "externalService",
                  "type": 2,
                  "description": "Select the external service you want to monitor",
                  "isRequired": true,
                  "typeSettings": {
                    "additionalResourceOptions": [],
                    "showDefault": false
                  },
                  "jsonData": "[\n    {\"label\":\"oneIdentity\",\"value\":\"oneid.pagopa.it\",\"selected\": true},\n    {\"label\":\"bizEvents\",\"value\":\"bizevents\",\"selected\": true},\n    {\"label\":\"payments pull\",\"value\":\"pagopa-gpd-payments-pull\",\"selected\": true}\n]",
                  "timeContext": {
                    "durationMs": 86400000
                  },
                  "value": "bizevents"
                }
              ],
              "style": "pills",
              "queryType": 0,
              "resourceType": "microsoft.operationalinsights/workspaces"
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "parameters - 9"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,interval), cloud_RoleName\r\n| render timechart",
              "size": 0,
              "showAnalytics": true,
              "title": "Number of calls to the external service \" {externalService:label} \" made by arc-be",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ]
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Number of calls to the external service made by arc-be"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,interval),resultCode\r\n| render timechart",
              "size": 0,
              "showAnalytics": true,
              "title": "Number of calls to the external service \" {externalService:label} \" divided by resultCode",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ]
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Number of calls to the external service divided by resultCode"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=count() by bin(timestamp,interval), operation_Name\r\n| render timechart",
              "size": 0,
              "showAnalytics": true,
              "title": "Number of calls to the external service \" bizEvents \" divided by API",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ]
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Number of calls to the external service \" bizEvents \" divided by API"
          },
          {
            "type": 3,
            "content": {
              "version": "KqlItem/1.0",
              "query": "let startTime = {timeRangeOverall:start};\r\nlet endTime = {timeRangeOverall:end};\r\nlet interval = totimespan({timeSpan:label});\r\n\r\ndependencies\r\n| where timestamp between (startTime .. endTime)\r\n| where cloud_RoleName startswith \"pagopaarcbe\"\r\n| where data has (\"{externalService}\")\r\n| summarize total=percentile(duration,95) by bin(timestamp,interval)\r\n| render timechart",
              "size": 0,
              "showAnalytics": true,
              "title": "Duration of calls to the external service \" {externalService:label} \" made by arc-be",
              "timeContextFromParameter": "timeRangeOverall",
              "queryType": 0,
              "resourceType": "microsoft.insights/components",
              "crossComponentResources": [
                "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
              ],
              "visualization": "timechart",
              "chartSettings": {
                "xAxis": "timestamp",
                "customThresholdLine": "800",
                "customThresholdLineStyle": 0
              }
            },
            "customWidth": "50",
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "externalService"
            },
            "name": "Duration of calls to the external service made by arc-be"
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "Kubernetes (AKS)",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook4ff901ba-f592-405c-b520-5b7c8f17bc06",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.containerservice/managedclusters",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}-aks"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 86400000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.containerservice/managedclusters",
                        "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_cpu_usage_percentage",
                        "aggregation": 4
                      }
                    ],
                    "title": "Cluster CPU Usage",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Cluster CPU Usage ",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook3fc01a1c-c9b3-4135-9a95-cfa0513d9af6",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.containerservice/managedclusters",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-${env}-aks-rg/providers/Microsoft.ContainerService/managedClusters/${prefix}-${location_short}-${env}-aks"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 86400000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.containerservice/managedclusters",
                        "metric": "microsoft.containerservice/managedclusters-Nodes (PREVIEW)-node_memory_working_set_percentage",
                        "aggregation": 4
                      }
                    ],
                    "title": "Cluster Memory Usage",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Cluster Memory Usage",
                  "styleSettings": {
                    "maxWidth": "50"
                  }
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook539a8e8b-cead-4bf5-97c0-e793617b2805",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.insights/components",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 86400000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.insights/components/kusto",
                        "metric": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/processCpuPercentageTotal",
                        "aggregation": 4,
                        "splitBy": [
                          "cloud/roleInstance"
                        ]
                      }
                    ],
                    "title": "Avg Process CPU by Cloud Role Instance",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Avg Process CPU by Cloud Role Instance"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbookdc92903c-915e-4148-806b-c77000e98c0c",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "resourceType": "microsoft.insights/components",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-core-monitor-rg/providers/Microsoft.Insights/components/${prefix}-${location_short}-core-appinsights"
                    ],
                    "timeContextFromParameter": "timeRangeOverall",
                    "timeContext": {
                      "durationMs": 86400000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.insights/components/kusto",
                        "metric": "microsoft.insights/components/kusto-Performance Counters-performanceCounters/memoryAvailableBytes",
                        "aggregation": 4,
                        "splitBy": [
                          "cloud/roleInstance"
                        ]
                      }
                    ],
                    "title": "Available Memory by Cloud Role Instance",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "Available Memory by Cloud Role Instance"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "resourceMetrics"
            },
            "name": "aks",
            "styleSettings": {
              "showBorder": true
            }
          },
          {
            "type": 12,
            "content": {
              "version": "NotebookGroup/1.0",
              "groupType": "editable",
              "title": "REDIS",
              "items": [
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbookf2611e3a-c3d4-4f29-88c5-f88da65801ea",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "color": "red",
                    "resourceType": "microsoft.cache/redis",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-redis-rg/providers/Microsoft.Cache/Redis/${prefix}-${location_short}-redis"
                    ],
                    "timeContext": {
                      "durationMs": 2592000000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.cache/redis",
                        "metric": "microsoft.cache/redis-Cache-allcachehits",
                        "aggregation": 3,
                        "splitBy": null,
                        "columnName": "Cache Hits"
                      }
                    ],
                    "title": "Cache Hits",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "metric - 3"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbookec52b1ea-a8e6-4655-b78d-3c78eff34268",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "color": "red",
                    "resourceType": "microsoft.cache/redis",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-redis-rg/providers/Microsoft.Cache/Redis/${prefix}-${location_short}-redis"
                    ],
                    "timeContext": {
                      "durationMs": 2592000000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.cache/redis",
                        "metric": "microsoft.cache/redis-Cache-allcachemisses",
                        "aggregation": 3,
                        "splitBy": null,
                        "columnName": "Cache Misses"
                      }
                    ],
                    "title": "Cache Misses",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "formatters": [
                        {
                          "columnMatch": "Subscription",
                          "formatter": 5
                        },
                        {
                          "columnMatch": "Name",
                          "formatter": 13,
                          "formatOptions": {
                            "linkTarget": "Resource"
                          }
                        },
                        {
                          "columnMatch": "Cache Misses Timeline",
                          "formatter": 5
                        },
                        {
                          "columnMatch": "microsoft.cache/redis-Cache-allcachemisses",
                          "formatter": 1,
                          "numberFormat": {
                            "unit": 0,
                            "options": null
                          }
                        }
                      ],
                      "rowLimit": 10000,
                      "labelSettings": [
                        {
                          "columnId": "Cache Misses",
                          "label": "Cache Misses"
                        },
                        {
                          "columnId": "Cache Misses Timeline",
                          "label": "Cache Misses Timeline"
                        }
                      ]
                    }
                  },
                  "customWidth": "50",
                  "name": "metric - 1"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook75f75039-2464-438d-bd9c-311aa989df12",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "color": "red",
                    "resourceType": "microsoft.cache/redis",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-redis-rg/providers/Microsoft.Cache/Redis/${prefix}-${location_short}-redis"
                    ],
                    "timeContext": {
                      "durationMs": 3600000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.cache/redis",
                        "metric": "microsoft.cache/redis-Cache-allserverLoad",
                        "aggregation": 3,
                        "splitBy": null
                      }
                    ],
                    "title": "Server Load",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "metric - 2"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook8df86730-de77-41fa-87b8-7e8d82456b68",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "color": "red",
                    "resourceType": "microsoft.cache/redis",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-redis-rg/providers/Microsoft.Cache/Redis/${prefix}-${location_short}-redis"
                    ],
                    "timeContext": {
                      "durationMs": 2592000000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.cache/redis",
                        "metric": "microsoft.cache/redis-Cache-allusedmemory",
                        "aggregation": 3,
                        "splitBy": null
                      }
                    ],
                    "title": "Used Memory",
                    "showOpenInMe": true,
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "metric - 3"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook110a06cd-d4e0-40a0-9c28-aa79d56cd4a4",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "color": "red",
                    "resourceType": "microsoft.cache/redis",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-redis-rg/providers/Microsoft.Cache/Redis/${prefix}-${location_short}-redis"
                    ],
                    "timeContext": {
                      "durationMs": 2592000000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.cache/redis",
                        "metric": "microsoft.cache/redis-Cache-allpercentprocessortime",
                        "aggregation": 3,
                        "splitBy": null
                      }
                    ],
                    "title": "CPU ",
                    "gridSettings": {
                      "rowLimit": 10000
                    }
                  },
                  "customWidth": "50",
                  "name": "metric - 4"
                },
                {
                  "type": 10,
                  "content": {
                    "chartId": "workbook675b47d8-982c-4e7a-a9d6-93f46223e893",
                    "version": "MetricsItem/2.0",
                    "size": 0,
                    "chartType": 2,
                    "color": "red",
                    "resourceType": "microsoft.cache/redis",
                    "metricScope": 0,
                    "resourceIds": [
                      "/subscriptions/${subscription_id}/resourceGroups/${prefix}-${location_short}-redis-rg/providers/Microsoft.Cache/Redis/${prefix}-${location_short}-redis"
                    ],
                    "timeContext": {
                      "durationMs": 2592000000
                    },
                    "metrics": [
                      {
                        "namespace": "microsoft.cache/redis",
                        "metric": "microsoft.cache/redis-Cache-errors",
                        "aggregation": 3,
                        "splitBy": null
                      }
                    ],
                    "title": "Error",
                    "tileSettings": {
                      "showBorder": false,
                      "titleContent": {
                        "columnMatch": "Name",
                        "formatter": 13
                      },
                      "leftContent": {
                        "columnMatch": "Value",
                        "formatter": 12,
                        "formatOptions": {
                          "palette": "auto"
                        },
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      }
                    },
                    "graphSettings": {
                      "type": 0,
                      "topContent": {
                        "columnMatch": "Subscription",
                        "formatter": 1
                      },
                      "centerContent": {
                        "columnMatch": "Value",
                        "formatter": 1,
                        "numberFormat": {
                          "unit": 17,
                          "options": {
                            "maximumSignificantDigits": 3,
                            "maximumFractionDigits": 2
                          }
                        }
                      }
                    },
                    "gridSettings": {
                      "formatters": [
                        {
                          "columnMatch": "Subscription",
                          "formatter": 5
                        },
                        {
                          "columnMatch": "Name",
                          "formatter": 13,
                          "formatOptions": {
                            "linkTarget": "Resource"
                          }
                        },
                        {
                          "columnMatch": "Metric",
                          "formatter": 1
                        },
                        {
                          "columnMatch": "Aggregation",
                          "formatter": 5
                        },
                        {
                          "columnMatch": "Value",
                          "formatter": 1
                        },
                        {
                          "columnMatch": "Timeline",
                          "formatter": 9
                        },
                        {
                          "columnMatch": "microsoft.cache/redis-Cache-errors",
                          "formatter": 1,
                          "numberFormat": {
                            "unit": 0,
                            "options": null
                          }
                        }
                      ],
                      "rowLimit": 10000,
                      "labelSettings": [
                        {
                          "columnId": "microsoft.cache/redis-Cache-errors",
                          "label": "Errors (Max)"
                        },
                        {
                          "columnId": "microsoft.cache/redis-Cache-errors Timeline",
                          "label": "Errors (Max) Timeline"
                        }
                      ]
                    }
                  },
                  "customWidth": "50",
                  "name": "metric - 5"
                }
              ]
            },
            "conditionalVisibility": {
              "parameterName": "selectedTab",
              "comparison": "isEqualTo",
              "value": "resourceMetrics"
            },
            "name": "REDIS",
            "styleSettings": {
              "showBorder": true
            }
          }
        ]
      },
      "name": "wrapper"
    }
  ],
  "fallbackResourceIds": [
    "Azure Monitor"
  ],
  "$schema": "https://github.com/Microsoft/Application-Insights-Workbooks/blob/master/schema/workbook.json"
}
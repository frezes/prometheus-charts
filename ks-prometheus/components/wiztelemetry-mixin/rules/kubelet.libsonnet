{
  _config+:: {
    kubeletSelector: 'job="kubelet"',
    quantileP99: "0.99",
  },

  prometheusRules+:: {
    groups+: [
      {
        name: 'wiztelemetry-kubelet.rules',
        rules: [
          {
            record: 'node_quantile:kubelet_pod_worker_duration_seconds:histogram_quantile',
            expr: |||
                histogram_quantile(%(quantileP99)s, sum by (%(clusterLabel)s, instance, le)(rate(kubelet_pod_worker_duration_seconds_bucket{%(kubeletSelector)s}[5m])) * on(%(clusterLabel)s, instance) group_left(node) kubelet_node_name{%(kubeletSelector)s})
            ||| % $._config,
            labels: {
              quantile: "0.99",
            }
          },
          {
            record: 'node_quantile:kubelet_runtime_operations_duration_seconds:histogram_quantile',
            expr: |||
                histogram_quantile(%(quantileP99)s, sum by (%(clusterLabel)s, instance, operation_type, le)(rate(kubelet_runtime_operations_duration_seconds_bucket{%(kubeletSelector)s}[5m])) * on(%(clusterLabel)s, instance) group_left(node) kubelet_node_name{%(kubeletSelector)s})
            ||| % $._config,
            labels: {
              quantile: "0.99",
            }
          },
          {
            record: 'node_quantile:storage_operation_duration_seconds:histogram_quantile',
            expr: |||
                histogram_quantile(%(quantileP99)s, sum by (%(clusterLabel)s, instance, operation_name, volume_plugin, le)(rate(storage_operation_duration_seconds_bucket{%(kubeletSelector)s}[5m])) * on(%(clusterLabel)s, instance) group_left(node) kubelet_node_name{%(kubeletSelector)s})
            ||| % $._config,
            labels: {
              quantile: "0.99",
            }
          },
        ],
      },
    ],
  },
}

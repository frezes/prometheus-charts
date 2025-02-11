local platforms = {
  wiztelemetry: import './wiztelemetry.libsonnet',
};

// platformPatch returns the platform specific patch associated to the given
// platform.
local platformPatch(p) = if p != null && std.objectHas(platforms, p) then platforms[p] else {};

{
  // initialize the object to prevent "Indexed object has no field" lint errors
  local p = {
    values+:: $.values,
    alertmanager: {},
    blackboxExporter: {},
    grafana: {},
    kubePrometheus: {},
    kubernetesControlPlane: {},
    kubeStateMetrics: {},
    nodeExporter: {},
    prometheus: {},
    prometheusAdapter: {},
    prometheusOperator: {},
    pyrra: {},
    wiztelemetry: {}
  } + platformPatch($.values.common.platform),

  alertmanager+: p.alertmanager,
  blackboxExporter+: p.blackboxExporter,
  grafana+: p.grafana,
  kubeStateMetrics+: p.kubeStateMetrics,
  nodeExporter+: p.nodeExporter,
  prometheus+: p.prometheus,
  prometheusAdapter+: p.prometheusAdapter,
  prometheusOperator+: p.prometheusOperator,
  kubernetesControlPlane+: p.kubernetesControlPlane,
  kubePrometheus+: p.kubePrometheus,
  pyrra+: p.pyrra,
  wiztelemetry+: p.wiztelemetry,
}
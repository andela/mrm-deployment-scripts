data "template_file" "config_map_file" {
  template = "${file("${var.config_template_file}")}"
}

# This resource describes a null resource that triggers the redis config map file
resource "null_resource" "config" {
  triggers {
    config_file = "${md5(data.template_file.config_map_file.rendered)}"
  }

  depends_on = [
    "kubernetes_service.redis_service",
  ]

  provisioner "local-exec" {
    command = <<EOF
kubectl create clusterrolebinding cluster-admin-binding --clusterrole cluster-admin --user $(gcloud config get-value account)
kubectl apply -f ./redis/k8s-redis/redis-configmap.yml 
echo '${data.template_file.config_map_file.rendered}' | kubectl apply -f -
EOF
  }

}

data "template_file" "ingress_controller_config" {
  template = "${file("${var.ingress_controller_file}")}"
}
data "template_file" "ingress" {
  template = "${file("${var.ingress_file}")}"
}
# This resource describes a null resource that triggers the ingress_controller
resource "null_resource" "ingress_controller" {
  triggers {
    ingress_file           = "${md5(data.template_file.ingress.rendered)}"
    ingress_controller_file = "${md5(data.template_file.ingress_controller_config.rendered)}"
  }

  depends_on = [
       "kubernetes_service.redis_service",
  ]

  provisioner "local-exec" {
    command = <<EOF
kubectl apply -f ./redis/k8s-redis/ingress/mandatory.yml 
echo '${data.template_file.ingress.rendered}' | kubectl apply -f -
kubectl apply -f ./redis/k8s-redis/ingress/nginx-ingress-controller-config.yml
echo '${data.template_file.ingress_controller_config.rendered}' | kubectl apply -f -
EOF
  }
}

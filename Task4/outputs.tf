output "data_platform_ip" {
  value = yandex_compute_instance.data_platform.network_interface[0].nat_ip_address
}

output "kafka_ip" {
  value = yandex_compute_instance.kafka.network_interface[0].nat_ip_address
}

output "bi_ip" {
  value = yandex_compute_instance.bi.network_interface[0].nat_ip_address
}
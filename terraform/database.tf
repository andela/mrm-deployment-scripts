// create a database instance for postgresql

resource "google_sql_database_instance" "converge_database_instance" {
  name = "converge-postgres"
  database_version = "${var.database_version}"
  region = "${var.gcloud_region}"
  count = "1"

  settings {
    tier = "${var.database_tier}"
    disk_autoresize = "${var.disk_autoresize}"
    availability_type = "REGIONAL"
    ip_configuration = {
        ipv4_enabled = "${var.ipv4_enabled}"
        authorized_networks = [
            {
                name = "all"
                value = "0.0.0.0/0"
            }
        ]
    }

    backup_configuration {
        enabled = true
        start_time = "${var.backup_start_time}"
    } 
  }
}

// Database user
resource "google_sql_user" "converge_database_user" {
    count = "1"
    name =  "${var.database_user}"
    password = "${var.database_password}"
    instance = "${google_sql_database_instance.converge_database_instance.name}"
}

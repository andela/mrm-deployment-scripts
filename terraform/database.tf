
// create a database instance for postgresql

resource "google_sql_database_instance" "converge_database_instance" {
  name = "converge-instance"
  database_version = "${var.database_version}"
  region = "${var.gcloud_region}"

  settings {
    tier = "${var.database_tier}"
    disk_autoresize = "${var.disk_autoresize}"
    ip_configuration = {
        ipv4_enabled = "${var.ipv4_enabled}"
        authorized_networks = [
            {
                name = "lagos_1"
                value = "41.75.89.154"
            },
            {
                name = "lagos_2"
                value = "169.239.188.10"
            },
            {
                name = "NBO"
                value = "105.21.32.90"
            },
            {
                name = "NBO_2"
                value = "105.27.99.66"
            },
            {
                name = "NBO_3"
                value = "41.90.97.134"
            },
            {
                name = "Kampala"
                value = "105.21.72.66"
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
    name =  "${var.database_user}"
    password = "${var.database_password}"
    instance = "${google_sql_database_instance.converge_database_instance.name}"
}



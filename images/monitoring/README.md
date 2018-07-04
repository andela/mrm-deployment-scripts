## MONITORING

### Tech Stack
>- ELK Stack
>- Stackdriver

### ELK Stack
The [ELK stack](https://www.elastic.co/guide/en/elastic-stack/6.3/installing-elastic-stack.html) is a combination of Elasticsearch, Logstash, and Kibana. It is used in this project for centralized logging and analytics of all instances in the infrastructure.

- **Elasticsearch** is the search and analysis system where data is stored from where it ios fetched and provides all search and analysis results
- **Logstash** parses and processes logs thereby making them structured before forwarding to the Elasticsearch
- **Kibana** is a visualization platform that allows you to build and view graphs, dashboards to help understand the data as not to work with the raw data Elasticsearch returns.

####Beats
These are light weight log shippers installed on the Frontend and Backend servers in this infrastructure for collecting logs and metrics. The two beats used in this project are the Filebeat and Metricbeat.
- *[Filebeat](https://www.elastic.co/guide/en/beats/filebeat/6.3/filebeat-getting-started.html)*: is used for collecting and shipping log files
- *[Metricbeat](https://www.elastic.co/guide/en/beats/metricbeat/6.3/metricbeat-getting-started.html)*: Collects and reports system level metrics of all instances created in the project

####Stackdriver
Stackdriver is the monitoring platform used in this project to provide information about the health of the frontend and backend instances in use by the application.
Services such as Uptime checks which verifies that the frontend and backend web servers are always accessible, and also the Alerting poilicies which are set of rules to control notification if uptime checks fails, were utilised for this project and are listed below:
- Uptime Checks
	- [Converge API Check](https://app.google.stackdriver.com/uptime/ce28c59ef8e1eb587f39525ce8721209?project=learning-map-app) (Backend)
	- [Converge Front Check](https://app.google.stackdriver.com/uptime/d1465fc3d44a9f062ee916ed1d7d7b88?project=learning-map-app) (Frontend)

- Alerting Policies
	- [Converge Frontend 80%](https://app.google.stackdriver.com/policy-advanced/9430850246973661579?project=learning-map-app) : Notifications get triggered if CPU usage for Frontend instances gets above 80% for 2 minutes
	- [Converge Backend Uptime Policy](https://app.google.stackdriver.com/policy-advanced/15157648660711930315?project=learning-map-app) : Notifications get triggered if Uptime check fails for Backend servers
	- [Converge Backend 80%](https://app.google.stackdriver.com/policy-advanced/14817378124970581038?project=learning-map-app) : Notifications get triggered if CPU usage for Backend instances gets above 80% for 2 minutes
	- [Converge Frontend Uptime Policy](https://app.google.stackdriver.com/policy-advanced/10733518375699880190?project=learning-map-app) : Notifications get triggered if Uptime check fails for Frontend servers
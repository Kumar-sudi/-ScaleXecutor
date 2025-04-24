#ScaleXecutor
ScaleXecutor is a dynamic performance-scaling utility designed for DB systems handling high-volume transactions during peak BAU hours. It utilizes Linux shell scripting, Oracle PL/SQL, and DevOps automation.


![image alt](https://github.com/Kumar-sudi/-ScaleXecutor/blob/main/ChatGPT%20Image%20Apr%2020,%202025,%2009_10_27%20PM.png?raw=true)

📁 GitHub Repo Structure:
pgsql
CopyEdit
scalexecutor/
├── README.md
├── architecture/
│   ├── Scalability_Design_Diagram.png
│   └── Flowchart_ThreadCreation.pdf
├── scripts/
│   ├── monitor_db_load.sh
│   ├── trigger_threads.sh
│   ├── resume_bau.sh
│   └── utils.sh
├── plsql/
│   ├── thread_processor_pkg.sql
│   ├── batch_deferral_proc.sql
│   ├── log_monitor_func.sql
│   └── exception_handling_pkg.sql
├── config/
│   ├── thresholds.conf
│   └── batch_priority.conf
├── devops/
│   ├── teamcity_pipeline.yaml
│   ├── udeploy_config.json
│   ├── git_hooks/
│   └── jira_snow_integration/
├── windows_scripts/
│   └── fallback_batch_handler.bat
└── cron/
    └── scalexecutor_cronjobs.txt



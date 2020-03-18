##GKE Preemtible Killer
Source: https://github.com/estafette/estafette-gke-preemptible-killer.git

Source version: 1.2.5
### Why?
When creating a cluster, all the node are created at the same time and should be deleted after 24h of activity. To prevent large disruption, the estafette-gke-preemptible-killer can be used to kill instances during a random period of time between 12 and 24h. It makes use of the node annotation to store the time to kill value.

### How does that work ?
At a given interval, the application get the list of preemptible nodes and check weither the node should be deleted or not. If the annotation doesn't exist, a time to kill value is added to the node annotation with a random range between 12h and 24h based on the node creation time stamp. When the time to kill time is passed, the Kubernetes node is marked as unschedulable, drained and the instance deleted on GCloud.

### Known limitations

* Pods in selected nodes are deleted, not evicted.
* Currently deletion time is based on node creation time, so if you deploy this tool when your instances have over 12h then you may experience a lot of nodes getting deleted at once.
* Selecting node pool is not supported yet, the code is processing ALL preemptible nodes attached to the cluster, and there is no way to limit it even via taints nor annotations
* This tool increases the chances to have many small disruptions instead of one major disruption.
* This tool does not guarantee that major disruption is avoided - GCP can trigger large disruption because the way preemptible instances are managed. Ensure your have PDB and enough of replicas, so for better safety just use non-preemptible nodes in different zones. You may also be interested in estafette-gke-node-pool-shifter.

### Terraform providers:
* google (v 3.12.0)
* kubernetes (v 1.11.1)
* helm (v 1.0.0)

### Usage

##### Examples:
 ```shell script
module "preemtible-killer" {
  source = "git::*"
  whitelist_hours = ["09:00 - 12:00, 13:00 - 18:00"]
  blacklist_hours = ["07:00 - 19:00"]
  drain_timeout = "100"
  interval_checks = "60"
}
```
 ```shell script
module "preemtible-killer" {
  source = "git::*"
  whitelist_hours = ["09:00 - 12:00, 13:00 - 18:00"]
}
```

##### You can use variables to configure the following settings:
| Variables (optionals)  | Default  | Description
| ---------------------- | -------- | -----------------------------------------------------------------
| BLACKLIST_HOURS        |          | List of UTC time intervals in the form of `["09:00 - 12:00, 13:00 - 18:00"]` in which deletion is NOT allowed
| DRAIN_TIMEOUT          | 300      | Max time in second to wait before deleting a node
| INTERVAL               | 600      | Time in second to wait between each node check
| WHITELIST_HOURS        |          | List of UTC time intervals in the form of `["07:00 - 19:00"]` in which deletion is allowed and preferred
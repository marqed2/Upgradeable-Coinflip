# Transparent Proxy Model and UUPS Proxy Model
In UUPS proxy model the upgrade is handled by the way we implement it, meaning it is customizable. On the other had in the Transparent proxy model the upgrade is included in the proxy itself.
The UUPS includes a standardized function for upgrading the implementation contract, called upgradeTo. This allows for upgrades without needing to change the address of the proxy contract itself, making the upgrade process more seamless and reducing the risk of disruption to users or other contracts interacting with the proxy.

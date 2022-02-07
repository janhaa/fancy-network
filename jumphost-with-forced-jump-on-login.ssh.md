Let's assume following configuration:

```
client <--> jumphost <--> target-host-1
                     <--> target-host-2
```

We want the client to be able to login like following

`ssh target-host-1@jumphost`

and automatically force the connection to tunnel to target-host-1.

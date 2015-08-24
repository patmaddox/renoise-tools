# Because not everything has to hit 0 dB.

Automatically attenuates samples by 12 dB when added to a Renoise project.

You can think of this as a tool to create "sample headroom" as opposed to the "track headroom" configuration setting. The sample's volume is attenuated before hitting any instrument fx.

## Known bugs

* Doesn't attentuate samples When "create multi sampled instruments is enabled" and you drag multiple samples to the sample list

## TODO

* Make the attenuation factor configurable (based on preview volume?)
* Apply it to instruments as well? xrni & plugins...
* Be smarter about attenuating... don't do it if the sample is already quiet

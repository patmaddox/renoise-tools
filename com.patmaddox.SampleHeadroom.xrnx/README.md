# Because not everything has to hit 0 dB.

Creates sample headroom by automatically attenuating samples by 12 dB when added to a Renoise project.

What's the difference between this and the track headroom setting? Sample headroom creates headroom before hitting any instrument fx, whereas track headroom comes after the entire instrument fx chain.

In the sample editor tab, samples are automatically attenuated only when the disk browser is open (so you can duplicate samples without changing their volume).

When rendering to a sample, it should not adjust the new sample's volume at all.

## Known bugs

* Doesn't attentuate samples When "create multi sampled instruments is enabled" and you drag multiple samples to the sample list

## TODO

* Make the attenuation factor configurable (based on preview volume?)
* Apply it to instruments as well? xrni & plugins...
* Be smarter about attenuating... don't do it if the sample is already quiet

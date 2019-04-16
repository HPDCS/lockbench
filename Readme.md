# Lockbench - A benchmarks suite for evaluating lock implementations

### Build

Compile the suite by simply typing make and tests will be ready to run.

```sh
$ make
```
### Running default benchmarks

Go to the script folder and generate the configuration for your machine by typing the following command:

```sh
$ cd script
$ ./create_machine_conf.sh
```

It will generate a configuration file in `script/machine_conf/`.

Now, you can run standard benchmarks by executing:

```sh
$ ./run_rand_batch_test.sh machine_conf/<your machine conf> tests_conf/<tests conf> thread_conf/<thread conf>
```

### Plotting results

Obtaining plots resuming the benchmark results is quite straightforward, but it might require some minutes.
1. First aggregate results by executing the following command
`./generate_dat.sh machine_conf/<your machine conf> tests_conf/<tests conf>`
2. Obtain the plots
`./plot_results.sh machine_conf/<your machine conf> tests_conf/<tests conf>`
3. Find the charts in the `plots` directory

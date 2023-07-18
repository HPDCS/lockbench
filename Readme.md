# Lockbench - A benchmarks suite for evaluating lock implementations

### Dependencies

Install these software before using Lockbench:

1. gnuplot
2. texlive-font-utils

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
$ ./run_rand_batch_test.sh machine_conf/<your_machine.conf> tests_conf/<test_selected.conf> thread_conf/<threads_selected.conf>
```

### Plotting results

Obtaining plots resuming the benchmark results is quite straightforward, but it might require some minutes.

1. First aggregate results by executing the following command:
```sh
$ ./generate_dat.sh tests_conf/<test_selected.conf> machine_conf/<your_machine.conf> thread_conf/<threads_selected.conf>
```
2. Obtain the plots:
```sh
$ ./plot_results.sh tests_conf/<test_selected.conf> machine_conf/<your_machine.conf> thread_conf/<threads_selected.conf>
```
3. Find the charts in the `plots` directory

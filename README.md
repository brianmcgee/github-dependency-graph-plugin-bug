# Github Dependency Graph Plugin Bug

> *NOT A BUG*: this is expected behaviour, explained [here](https://github.com/gradle/github-dependency-graph-gradle-plugin/issues/138)

This repository is designed to reproduce a possible issue with the [Github Dependency Graph Plugin] whereby `buildscript`
dependencies are not being captured by the `SimpleDependencyGraphPlugin`.

[Github Dependency Graph Plugin]: https://github.com/gradle/github-dependency-graph-gradle-plugin/issues/138

## Requirements 

This was tested with the following:

- openjdk 19.0.2 2023-01-17
- Gradle 8.7, revision: 650af14d7653aa949fce5e886e685efc9cf97c10

## Explanation

Dependency locking has been enabled for buildscript and normal dependencies. The lock files were generated using:

```
gradle :resolveAndLockAll --write-locks 
```

You can see the resolved dependencies in the `lockfiles` directory. Specifically, `lockfiles/buildscript-gradle.lockfile` 
contains the following example plugin dependency: 

```
com.diffplug.spotless:com.diffplug.spotless.gradle.plugin:6.25.0=classpath`
```

Run the following command to generate the dependency report, as recommended [here](https://github.com/gradle/github-dependency-graph-gradle-plugin?tab=readme-ov-file#using-the-plugin-to-generate-dependency-reports) 

```
gradle -I init.gradle --dependency-verification=off --no-configuration-cache --no-configure-on-demand :ForceDependencyResolutionPlugin_resolveAllDependencies
```

If you then look in `build/reports/dependency-graph-snapshots` you will not find an entry for the following plugin 
dependencies:

* `com.github.johnrengelman.shadow:com.github.johnrengelman.shadow.gradle.plugin:8.1.1`
* `com.diffplug.spotless:com.diffplug.spotless.gradle.plugin:6.25.0`

This would imply it's not capturing all the buildscript / plugin dependencies. 

> Note: I've included the build report that I'm seeing

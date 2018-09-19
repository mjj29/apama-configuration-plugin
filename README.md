# apama-configuration-plugin
Apama EPL plugin to expose configuration items to EPL

## Building the plugin

To build the plugin you just need to copy ConfigurationPlugin.py to `$APAMA_WORK/lib` (Linux) `%APAMA_WORK%\lib` (Windows) and eventdefinitions/ConfigurationPlugin.mon to `$APAMA_WORK/monitors` (Linux) `%APAMA_WORK%\monitors` (Windows)

To generate the Apama documentation for the ConfigurationPlugin module run this command on Linux:

    java -jar $APAMA_HOME/lib/ap-generate-apamadoc.jar doc eventdefinitions

Or on Windows:

    java -jar %APAMA_HOME%\lib\ap-generate-apamadoc.jar doc eventdefinitions

## Building using Docker

There is a provided Dockerfile which will build the plugin, run tests and produce an image which is your base image, plus the CSV plugin. Application images can then be built from this image. To build the image run:

    docker build -t apama_with_configuration_plugin .

By default the public docker images from Docker Store for 10.3 will be used (once 10.3 has been released). To use an older version run:

    docker build -t apama_with_configuration_plugin --build-arg APAMA_VERSION=10.1 .

To use custom images from your own repository then use:

    docker build -t apama_with_configuration_plugin --build-arg APAMA_BUILDER=builderimage --build-arg APAMA_IMAGE=runtimeimage .

## Running tests

To run the tests for the plugin you will need to use an Apama command prompt. Then run the tests from within the tests directory:

    pysys run

## Using the plugin

To use the plugin you must first import it into your configuration and declare the properties you want to make available:

    eplPlugins:
      configurationPlugin:
        pythonFile: ${APAMA_WORK}/lib/ConfigurationPlugin.py
        config:
          PROPERTY_NAME: ${PROPERTY_NAME}
          OTHER_PROPERTY: ${OTHER_PROPERTY}

Then inject the ConfigurationPlugin.mon and call the static actions from your EPL code:

    string prop := <string> ConfigurationPlugin.getProperty("PROPERTY_NAME");
	 dictionary<string, any> allprops := ConfigurationPlugin.getAllProperties();

Only properties that you name in the configuration file will be available in EPL.

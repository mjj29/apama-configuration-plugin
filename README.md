# apama-configuration-plugin
Apama EPL plugin to expose configuration items to EPL

## Building the plugin

To build the plugin you just need to copy ConfigurationPlugin.py to `$APAMA_WORK/lib` (Linux) `%APAMA_WORK%\lib` (Windows).

To generate the Apama documentation for the ConfigurationPlugin module run this command on Linux:

    java -jar $APAMA_HOME/lib/ap-generate-apamadoc.jar doc eventdefinitions

Or on Windows:

    java -jar %APAMA_HOME%\lib\ap-generate-apamadoc.jar doc eventdefinitions

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

from apama.eplplugin import EPLAction,EPLPluginBase

class ConfigurationPlugin(EPLPluginBase):
    def __init__(self, init):
        super(ConfigurationPlugin,self).__init__(init)
    @EPLAction("action<> returns dictionary<string, any>")
    def getAllProperties(self):
        return self.getConfig()
    @EPLAction("action<string> returns any")
    def getProperty(self, name):
        return self.getConfig().get(name)
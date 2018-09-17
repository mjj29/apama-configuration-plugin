from pysys.constants import *
from apama.basetest import ApamaBaseTest
from apama.correlator import CorrelatorHelper
import re

class PySysTest(ApamaBaseTest):
	def execute(self):
		correlator = CorrelatorHelper(self, name='testcorrelator')
		correlator.start(logfile='testcorrelator.log', config=PROJECT.APAMA_WORK+"/hackweek/apama-configuration-plugin/config/CorrelatorConfig.yaml", arguments=['-DCOMMAND_LINE=commandValue'])
		correlator.injectEPL(filenames=['ConfigurationPlugin.mon'], filedir=PROJECT.APAMA_WORK+"/hackweek/apama-configuration-plugin/eventdefinitions")
		correlator.injectEPL(filenames=['test.mon'])
		correlator.flush() 

	def validate(self):
            self.assertGrep('testcorrelator.out', expr='ERROR', contains=False)
            self.assertGrep('testcorrelator.out', expr='"APAMA_WORK":any\(string,"%s"\)'%re.sub(r'[\\]', r'\\\\\\\\', PROJECT.APAMA_WORK))
            self.assertGrep('testcorrelator.out', expr='"COMMAND_LINE":any\(string,"commandValue"\)')
            self.assertGrep('testcorrelator.out', expr='"DIRECT_VALUE":any\(sequence<any>,\[any\(string,"1"\),any\(string,"2"\),any\(string,"3"\),any\(string,"4"\)\]\)')
            self.assertGrep('testcorrelator.out', expr='^any\(string,"commandValue"\)')
            self.assertGrep('testcorrelator.out', expr='^any\(\)')

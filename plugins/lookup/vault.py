from ansible import utils, errors, constants
import os
import codecs
import subprocess

class LookupModule(object):

    def __init__(self, basedir=None, **kwargs):
        self.basedir = basedir

    def run(self, terms, inject=None, **kwargs):

        terms = utils.listify_lookup_plugin_terms(terms, self.basedir, inject)
        password_file = os.path.expanduser(constants.DEFAULT_VAULT_PASSWORD_FILE)
        vault = utils.VaultLib(password=subprocess.check_output([password_file]).strip('\n'))
        ret = []

        # this can happen if the variable contains a string, strictly not desired for lookup
        # plugins, but users may try it, so make it work.
        if not isinstance(terms, list):
            terms = [ terms ]

        for term in terms:
            basedir_path  = utils.path_dwim(self.basedir, term)
            relative_path = None
            playbook_path = None

            # Special handling of the file lookup, used primarily when the
            # lookup is done from a role. If the file isn't found in the
            # basedir of the current file, use dwim_relative to look in the
            # role/files/ directory, and finally the playbook directory
            # itself (which will be relative to the current working dir)
            if '_original_file' in inject:
                relative_path = utils.path_dwim_relative(inject['_original_file'], 'files', term, self.basedir, check=False)
            if 'playbook_dir' in inject:
                playbook_path = os.path.join(inject['playbook_dir'], term)

            for path in (basedir_path, relative_path, playbook_path):
                if path and os.path.exists(path):
                    with open(path) as f:
                        content = f.read()
                    if vault.is_encrypted(content):
                        ret.append(vault.decrypt(content))
                    break
            else:
                raise errors.AnsibleError("could not locate file in lookup: %s" % term)

        return ret

# python 3 headers, required if submitting to Ansible
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = """
        lookup: aws_credentials
        author: xdays <easedays@gmail.com>
        version_added: "0.9"
        short_description: get aws credentials
        description:
            - This lookup returns the access_key and secret_key of aws profile
        options:
          _terms:
            description: name(s) of profile to get
            required: False
"""
from ansible.errors import AnsibleError, AnsibleParserError
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display
import boto3
import os

display = Display()


class LookupModule(LookupBase):
    def run(self, terms, variables=None, **kwargs):
        ret = []
        if not terms:
            profile_name = os.environ.get("AWS_PROFILE", "default")
            cred = boto3.session.Session(
                profile_name=profile_name).get_credentials()
            ret.append(cred.__dict__)
        for term in terms:
            cred = boto3.session.Session(profile_name=term).get_credentials()
            ret.append(cred.__dict__)
        if "attr" in kwargs:
            ret = [i[kwargs["attr"]] for i in ret]
        return ret

from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


def inventory(res):
    if type(res) == type(dict()):
        engine = create_engine('mysql://root:changeme@localhost/everops', echo=False)
        Base = declarative_base()
        class Instances(Base):
            __tablename__ = 'instances'
            id = Column(Integer, primary_key=True)
            ip = Column(String(50))
            os = Column(String(50))
            def __repr__(self):
                return "<Instance(ip='%s', os='%s')>" % (self.ip, self.os)

        Session = sessionmaker(bind=engine)
        session = Session()
        facts = res['ansible_facts']
        ip = facts['ansible_eth0']['ipv4']['address']
        os = '%s-%s' % (facts['ansible_distribution'], facts['ansible_distribution_version'])
        instance = session.query(Instances).filter_by(ip=ip).first()
        if instance:
            instance.os = os
        else:
            session.add(Instances(ip=ip, os=os))
        session.commit()

class CallbackModule(object):

	def runner_on_ok(self, host, res):
		inventory(res)

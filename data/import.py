#!/usr/bin/env python
# -*- coding: latin-1 -*-
from sqlalchemy import *
from sqlalchemy.orm import relationship, backref
from sqlalchemy.orm import mapper, sessionmaker, clear_mappers
from sqlalchemy.ext.declarative import declarative_base
import sys
import xml.etree.ElementTree as ET
import datetime
import json
from pprint import pprint as pp
import requests
import time
import os
import csv
import codecs
from openpyxl import Workbook, load_workbook
import importlib
import hashlib

class Question(object):
    pass


class Tag(object):
    pass

engine = create_engine('mysql://root:vhw89evhc7e8cby9e-f4&g3@188.166.45.118/pinder')
metadata = MetaData()
clear_mappers()
db_tags = Table('tags', metadata, autoload=True, autoload_with=engine)
mapper(Tag, db_tags)

db_questions = Table('questions', metadata, autoload=True, autoload_with=engine)
mapper(Question, db_questions)

Session = sessionmaker(bind=engine)
self.session = Session()

print 'test'

	def add_location(self, location, opening_hours=None):
		location.brand_id = self.id
		location.checksum = self.get_location_checksum(location)
		location.created_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
		location.updated_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
		location.source_timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

		exsiting = self.session.query(Location).filter_by(checksum=location.checksum).first()

		if exsiting:
			location = exsiting
		else:
			self.session.add(location)
			self.session.commit()


			if opening_hours:
				opening_hours.location_id = location.id
				opening_hours.checksum = self.get_opening_hours_checksum(opening_hours)
				opening_hours.created_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
				opening_hours.updated_at = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
				self.session.add(opening_hours)
				self.session.commit()

		return location.id

	def get_location_checksum(self, location):
		string = unicode(location.brand_id) + unicode(location.housenumber) + unicode(location.city) + unicode(location.postcode) + unicode(location.street)
		return hashlib.sha224(string.encode('utf-8')).hexdigest()

	def get_opening_hours_checksum(self, opening_hours):
		string = unicode(opening_hours.location_id) + unicode(opening_hours.monday) + unicode(opening_hours.tuesday) + unicode(opening_hours.wednesday) + unicode(opening_hours.thursday) + unicode(opening_hours.friday) + unicode(opening_hours.saturday) + unicode(opening_hours.sunday) + unicode(opening_hours.holiday) 
		return hashlib.sha224(string.encode('utf-8')).hexdigest()

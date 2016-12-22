# Cookbook Name:: polignu
# __Attribute::__server__
#
# Copyright (C) 2016 Diego Rabatone Oliveira.
#
# This file is part of Radar Parlamentar.
#
# SiteDeploy is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.

# SiteDeploy is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# Radar Parlamentar.  If not, see <http://www.gnu.org/licenses/>.

# mysql variables
default['mysql']['root_password'] = nil
default['mysql']['polignu']['user'] = nil
default['mysql']['polignu']['password'] = nil
default['mysql']['polignu']['database_name'] = nil
default['mysql']['poligen']['user'] = nil
default['mysql']['poligen']['password'] = nil
default['mysql']['poligen']['database_name'] = nil
default['mysql']['users_privileges'] = [:select, :update, :insert]
default['mysql']['bind_address'] = nil

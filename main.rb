#Grace Meredith
#CPE 400 Final Project
#Due: 12 December 2022

#Routing protocol with focus on energy convservation
#Utilizing the Low-Energy Adaptive Cluster Heirarchy protocol.

#Access Python's matplotlib for visualizer using Pycall
require 'matplotlib'
require 'matplotlib/pyplot'
$plt = Matplotlib::Pyplot

#
#
# => initialize variables
#
#

$cluster_probability = 30
$current_round = 1
$sensor_list = Array.new
$cluster_heads = Array.new
$rnd = Random.new(10)

#
#
# => Sensor object created for each node
#
#

class Sensor 

	def initialize(mac_address, x, y, id)
	    @sensor_data = Array.new
	    @mac_address = mac_address
	    @current_cluster_head = false
	    @previous_cluster_head = false
	    @battery_life = 100
	    @x_pos = x
	    @y_pos = y
	    @transmit_mac_address = 'null'
	    @transmit_sensor = ' '
	    @sensor_id = id
	end
	
	#Recieve Signal Strength Indicator Protocol
	def RSSI(signals)
		min = 10000 #set min to an arbitruary high number
		signals.each do |signal|
			signal_strength = dist([@x_pos,@y_pos],[signal.x_pos,signal.y_pos])
			if !@transmit_mac_address
				min = signal_strength
				@transmit_mac_address = signal.mac_address
			elsif signal_strength < min
				min =  signal_strength
				@transmit_mac_address = signal.mac_address
				@transmit_sensor = signal
			end
		end

		puts("Sensor " + self.sensor_id.to_s + " at position " + self.x_pos.to_s + "," + self.y_pos.to_s + " is responding to cluster head " + self.transmit_mac_address.to_s + "'s advertisement")
	end

	#Getters and Setters for Sensor attributes
	def sensor_data()
		@sensor_data
	end

	def sensor_data=val
		@sensor_data = val
	end

	def mac_address
		@mac_address
	end

	def mac_address=val
		@mac_address
	end

	def current_cluster_head
		@current_cluster_head
	end

	def current_cluster_head=val
		@current_cluster_head = val
	end

	def previous_cluster_head
		@previous_cluster_head
	end

	def previous_cluster_head=val
		@previous_cluster_head = val
	end

	def battery_life
		@battery_life
	end

	def battery_life=val
		@battery_life = val
	end

	def x_pos
		@x_pos
	end

	def x_pos=val
		@x_pos = val
	end

	def y_pos
		@y_pos
	end

	def y_pos=val
		@y_pos = val
	end

	def transmit_mac_address
		@transmit_mac_address
	end

	def transmit_mac_address=val
		@transmit_mac_address = val
	end

	def transmit_sensor
		@transmit_sensor
	end

	def transmit_sensor=val
		@transmit_sensor = val
	end

	def sensor_id
		@sensor_id
	end

	def sensor_id=val
		@sensor_id = val
	end
end

#
#
# => Functions for running the simulations
#
#

#Each sensor in the network determines whether or not it will be a sensor head for the round.
def ChooseClusterHead()
	puts("\n")
	$cluster_heads.each do |c|
		$cluster_heads.delete(c)
	end

	#Loop so that we are guranteeded at least one cluster head per round
	while $cluster_heads.length() < 1
		#For Each Sensor
		$sensor_list.each do |sensor|
			#Check to make sure sensor is still alive
			if sensor.battery_life > 0
				#Clear data and previous targeted cluster head from last round
				sensor.transmit_mac_address = 'null'
				sensor.sensor_data.each do |d|
					sensor.sensor_data.delete(d)
				end
				#Reset Current Sensor Flags
				if sensor.current_cluster_head
					sensor.current_cluster_head = false
				else
					#Calculate current probablity
					t_probablity = $rnd.rand(0..100)
					if t_probablity <= $cluster_probability
						#Check to make sure sensor has not already been a sensor
						unless sensor.previous_cluster_head
							sensor.current_cluster_head = true
							sensor.previous_cluster_head = true
							$cluster_heads.append(sensor)
							#Notify that sensor is cluster head for current round
							puts("Sensor " + sensor.sensor_id.to_s + " with MAC address of " + sensor.mac_address.to_s + " has been chosen to be a cluster head")
						else
							sensor.previous_cluster_head = false
						end
					end
				end
			end
		end
	end
end	

#Each of the elected sensor heads broadcast a signal to all nodes that were not elected sensor heads.
def Advertise_Signal()
	puts("\nCluster heads are broadcasting advertisements....")
	#For each sensor, compare position to determine closest cluster head
	$sensor_list.each do |sensor|
		#Check to make sure sensor is not dead
		if sensor.battery_life > 0
			unless sensor.current_cluster_head
				sensor.RSSI($cluster_heads)
			end
		end
	end
end

#create the schedules for each cluster using TDMA algorthm
def SetSchedule()
	puts("\nSchedule Creation Time Division Multiple Access")
	puts("Creating Schedule....")
	#For Each head, determine in what time order to allow sensor nodes to send data
	$cluster_heads.each do |heads|
		$sensor_list.each do |sensor|
			unless (sensor.current_cluster_head && sensor.battery_life <= 0)
				if sensor.transmit_mac_address == heads.mac_address
				end
			end
		end
	end
end					

#Based on the schedule, sensors send their data to the predetermined head.
#The sensor head compresses all received data from the sensors and then finally transmits the data to the base station.				
def CollectData()
	puts("\nCluster Heads are now Collecting Data...")

	#Cluster heads collect data from their sensor nodes
	$cluster_heads.each do |heads|
		$sensor_list.each do |sensor|
			unless sensor.current_cluster_head
				if sensor.transmit_mac_address == heads.mac_address && sensor.battery_life > 0
					#Generate Random Data
					val = $rnd.rand(100..200).to_s
					$plt.plot([heads.x_pos, sensor.x_pos], [heads.y_pos, sensor.y_pos])
					$plt.text((heads.x_pos + sensor.x_pos).div(2), (heads.y_pos + sensor.y_pos).div(2), val)
					sensor.sensor_data.append(val)
					heads.sensor_data.append(val)
					sensor.battery_life-= (sensor.sensor_data.length() * dist([sensor.x_pos,sensor.y_pos],[heads.x_pos,heads.y_pos]) *0.05)
				end
			end

			if heads.battery_life > 0
				val = $rnd.rand(100..200)
				heads.sensor_data.append(val)
				heads.battery_life-=(heads.sensor_data.length() * dist([sensor.x_pos,sensor.y_pos],[130,120]) * 0.05)	
				puts(heads.mac_address.to_s + " is transmitting to 00:00:00:00:00:00 ")	
			end
		end
	end
end	

#
#
# => supplementary functions
#
#

#returns the distance between two sensor nodes 
def dist(p1, p2)
    return Math.sqrt(((p1[0] - p2[0])*(p1[0] - p2[0])) + ((p1[1] - p2[1])*(p1[1] - p2[1])))
end

#returns a random MAC address to assign to a sensor node
def SetRandomMacAddress()
	mac = [ 0x00, 0x16, 0x3e,
		$rnd.rand(0x00..0x7f),
		$rnd.rand(0x00..0xff),
		$rnd.rand(0x00..0xff) ]

	return mac.join(":")
end

#
#
# => Main code 
#
#

#get the number of nodes from user
puts("Enter the amount of nodes in the network: ")
$num_nodes = gets

#give each node a randome mac address and initialize a sensor object for each node into a list of sensors
for i in (1..$num_nodes.to_i)
	r = self.SetRandomMacAddress
	$sensor_list.append(Sensor.new(r,($rnd.rand(0..100)), ($rnd.rand(0..100)), i))
end

#simulate each stage of LEACH by dividing into rounds until all the nodes have died, or run out of battery life
loop do
	puts("\n\nRound: " + $current_round.to_s)
	self.ChooseClusterHead()
	self.Advertise_Signal()
	self.SetSchedule()
	self.CollectData()

	sensors_alive = 0
	puts("\n")
	$cluster_heads.each do |heads|
		$sensor_list.each do |sensor|
			unless sensor.current_cluster_head
				puts("SENSOR " + sensor.sensor_id.to_s + " BATTERY: " + sensor.battery_life.to_s)
				if sensor.transmit_mac_address == heads.mac_address && sensor.battery_life > 0
					$plt.scatter(sensor.x_pos, sensor.y_pos)
					$plt.text(sensor.x_pos, sensor.y_pos, "Sensor " + sensor.sensor_id.to_s)
					sensors_alive+=1
				end
			end
		end	
		puts("HEAD " + heads.sensor_id.to_s + " BATTERY: " + heads.battery_life.to_s + "\n")	
		if heads.battery_life > 0
			sensors_alive+=1
			$plt.scatter(heads.x_pos, heads.y_pos)
			$plt.text(heads.x_pos,heads.y_pos,"Sensor Head: " + heads.sensor_id.to_s)
		end
	end
	
	title = 'Round '.to_s + $current_round.to_s
	$plt.title(title)
	if sensors_alive == 0
		puts("\nSimulation Over")
		puts("Network lasted " + $current_round.to_s + " rounds")
		break
	end

	$plt.show()
	$current_round+=1	
end			
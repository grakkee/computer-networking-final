Grace Meredith
CPE 400 Final Project
Due 12 December 2022

Hi, welcome to my project. My task was to create a dynamic routing mechanism with focus on energy conservation. Below are instructions for running the script. Please refer to the technical report **[cpe_report.pdf]** for detail on the algorithm, simulated protocols and results.

# Running the Program
 This project is written with Ruby. There are **two options** to view the running program. If neither option is sufficient for grading, please **email me at gmeredith@nevada.unr.edu** and we can schedule a live demo.
 
## Option 1: download the ruby interpreter.
To run the script on your Ubuntu/Debian machine, first download ruby: 
`$ sudo apt-get install ruby-full`.

Next, you will want to install the gem (library) used in the script:
`$ sudo gem install --pre matplotlib`.
More information on this library can be found here: https://github.com/mrkn/matplotlib.rb . This library was used for the visualizer in the program by accessing Python's matplotlib library through PyCall.

Finally, you can run the script! cd into the folder where main.rb resides and run:
`ruby main.rb`. 

> Note: a matplotlib window will pop up with each round of the simulation. to continue the program, just exit each windows as they pop up.
 
 ## Option 2: Watch a recorded simulation provided.
 In case there are malfunctions in running the script, I have provided a couple screen recordings of me running the simulation with various amounts of nodes. You can view them here: https://www.youtube.com/watch?v=xOLGOtR7FD8 and https://www.youtube.com/watch?v=pS5M589xb7I 
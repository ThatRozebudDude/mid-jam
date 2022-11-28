# STEALING FNF CHART GEN CODE FROM LATE 2020 LMAO

# Importing Image module from PIL package.
from mido import Message
from mido import MidiFile
import sys

# Creating an image object.
mid = MidiFile(sys.argv[1])

# Get needed params from user.name = input()
print("BPM: (Default \"100\")")
bpm = input()
print("Timestep: (Default \"120\")")
midiBpm = input()
print("Note Speed: (Default \"0.4\")")
speed = input()

# Set default params.
if(bpm == ""):
    bpm = "100"
if(speed == ""):
    speed = "0.4"
if(midiBpm == ""):
    midiBpm = "120"
    
midiBpm = int(midiBpm)
intBpm = int(bpm)
 
# Makin' that json output.
f = open("chart.json","w")
notes = ""

offset = 0.0

# Write initial chart info.
print("Starting write.\n")
f.write("{\"notes\":[")

totalTime = 0
colors = ["red", "blue", "green"]

#midi stuff goes here
for msg in mid:
    totalTime += msg.time
    if(msg.type == 'note_on'):
        notes += "\n[" + str((midiBpm/intBpm)*1000*totalTime + offset) + ", \""+ colors[msg.note - 37] +"\"],"
        print("Note added.\n")
    #print(msg)

# Close the last section and generate the rest of the song data. 
print("Finalizing json...\n")
if(notes != ""):
    f.write(notes[:-1] + "],")
else:
    f.write("],")
f.write("\n\"bpm\":" + bpm + ",\"speed\":" + speed + "}")

# Memory leaks are bad.
f.close()

print("Writing json complete! Goodbye...")
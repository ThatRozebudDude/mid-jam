# STEALING FNF CHART GEN CODE FROM LATE 2020 LMAO

# Importing Image module from PIL package.
from mido import Message
from mido import MidiFile
import sys
import json

# Creating an image object.
mid = MidiFile(sys.argv[1])

# Get needed params from user.name = input()
print("BPM: (Default \"100\")")
bpm = input()
print("Midi BPM: (Default \"120\")")
midiBpm = input()
print("Note Speed: (Default \"0.4\")")
speed = input()
print("Stage: (Default \"bar\")")
stage = input()

print("Lane 1 Skin: (Default \"red\")")
lane0Skin = input()
print("Lane 2 Skin: (Default \"blue\")")
lane1Skin = input()
print("Lane 3 Skin: (Default \"green\")")
lane2Skin = input()

print("Character 1: (Default \"donny\")")
char0 = input()
print("Character 2: (Default \"johnny\")")
char1 = input()
print("Character 3: (Default \"olive\")")
char2 = input()

# Set default params.
if(bpm == ""):
    bpm = "100"
if(speed == ""):
    speed = "0.4"
if(midiBpm == ""):
    midiBpm = "120"
if(stage == ""):
    stage = "bar"
    
if(lane0Skin == ""):
    lane0Skin = "red"
if(lane1Skin == ""):
    lane1Skin = "blue"
if(lane2Skin == ""):
    lane2Skin = "green"
    
if(char0 == ""):
    char0 = "donny"
if(char1 == ""):
    char1 = "johnny"
if(char2 == ""):
    char2 = "olive"
    
midiBpm = int(midiBpm)
intBpm = int(bpm)
 
# Makin' that json output.
f = open("chart.json","w")
notes = ""

offset = 0.0

# Write initial chart info.
print("Starting write.\n")

output = ""

#f.write("{\"notes\":[")
output += "{\"notes\":["

totalTime = 0
colors = [lane0Skin, lane1Skin, lane2Skin]

#midi stuff goes here
for msg in mid:
    totalTime += msg.time
    if(msg.type == 'note_on'):
        notes += "\n[" + str((midiBpm/intBpm)*1000*totalTime + offset) + ", " + str(msg.note - 37) + ", \""+ colors[msg.note - 37] +"\"],"
        print("Note added.\n")
    #print(msg)

# Close the last section and generate the rest of the song data. 
print("Finalizing json...\n")
if(notes != ""):
    #f.write(notes[:-1] + "],")
    output += notes[:-1] + "],"
else:
    #f.write("],")
    output += "],"
    
#f.write("\n\"bpm\":" + bpm + ",\"speed\":" + speed + "}")
output += "\n\"bpm\":" + bpm + ",\"speed\":" + speed + ",\"stage\":\"" + stage + "\",\"characters\":[\"" + char0 + "\",\"" + char1 + "\",\"" + char2 + "\"]}"
parsed = json.loads(output)

f.write(json.dumps(parsed, indent=4))

# Memory leaks are bad.
f.close()

print("Writing json complete! Goodbye...")
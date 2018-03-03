# TFC_EscapeRoom

Escape Room module for Technologies for Connectivities

## Module design - Group 10

Motivation

This quartile we will as a group create a high quality prototype and presentation in the escape room. This prototype is based on our module that we will develop in the coming weeks. Due to the basic setup of our module, it can be used in lots of different combinations with other modules. Our clients are the owners of all modules who can give a number as output and/or need a (yes/no) input. Our module makes it possible to verify whether the hint of another module is understood correctly by the players of the escape room.

**Requirements**

The module we design must be technical pleasing, aes­thetical and innovative, yet understandable and useful. With this we set requirements about the usability of a product and innova­tive challenges. What is meant by this is the following:

_Technical_

- --_Technical pleasing_: Our level makes use of different modules including our own module. Our module satisfies the requirements set by the course descriptions and ourself.
- --We will make several iterations and prototypes during the quartile based on the feedback and lecturers. In this way, this course will increase our knowledge about complex systems design and IOT.
- --The module will use the method described in chapter API.


_User_

- --_Aesthetical and innovative:_ Our design is intuitively pleasing. Intuitive pleasing means to us that a design is appreciated even without con­scious reasoning or conscious seeing it.
- --_Understandable and useful:_ design has a high usability and is suitable for an escape room.

- --Overall experience, challenging.

_Business_

- --Connect with other modules.
- --Our module need to verify outputs of other modules and when correct sent an positive output to the next module.
- --Potential of module is that it is widely applicable.
- --Not set in stone, possible to enlarge or extend the module.
- --Concept is clear but is not bound to a particular context. So, this module can be used in different game settings.

### Description

The module can receive data from one or more modules. The received data can be seen as hints, corresponding to a combination or set of numbers. These numbers represent the code that has to be filled into the module. Our module checks whether or not the input from the user is corresponding with the input number sent by the other module. If the correct code is filled in by the user, the module can send out a positive (yes, 1, etc.) message to the next module in line. If a wrong combination of code is filled in, the module does not send out data. More functions can be added to this module if necessary.

### API

Our module should be able to notify a calling module when the user entered the correct numeric code. This secret code is to be determined by an API call to our module.

The module accepts 2 types of messages as input: &#39;set&#39; and &#39;reset&#39;, indicated by the &#39;messagetype&#39; key. To prevent overriding the secret code, If a &#39;set&#39; message has arrived, the module will not accept any new &#39;set&#39; messages until a &#39;reset&#39; message has arrived from the same sender as the first &#39;set&#39; message.

Input

Set

| **key** | **type** | **pattern** |
| --- | --- | --- |
| type | string | &#39;set&#39; |
|

#
[ANNOTATION:

BY &#39;Tim Beurskens&#39;
ON &#39;2018-03-03T12:57:23&#39;
NOTE: &#39;Zover de documentatie van OOCSI aangeeft zijn arrays geen ondersteunde datatypen. De module zal daarom nog steeds een string moeten accepteren en intern moeten converteren naar een integer array.&#39;]

#
[ANNOTATION:

BY &#39;ezgi aytekin&#39;
ON &#39;2018-03-02T15:00:35&#39;
NOTE: &#39;is nu een int[] array geworden.&#39;]
code
 | string | /[0-9]+/ |
| duration | long |   |
| tries | int | &gt; 0 |

When the module receives this message, it will set the accepting secret code to _code_.

Parameters

_type_: Should be &#39;set&#39; to be a valid _set_ message.

_code_: A sequence of digits indication the secret code.

_duration_: A difference between the current unix timestamp and the time the code should be entered. If this value is less than zero, the timeout constraint will be removed.

_tries_: The maximum number of tries a user has before the module fails and resets.

Reset

| **key** | **type** | **pattern** |
| --- | --- | --- |
| type | string | &#39;reset&#39; |

When the module receives this message, it will reset the secret code and wait for new &#39;set&#39; messages.

Parameters

_type_: Should be &#39;reset&#39; to be a valid _reset_ message.

Output

Result

| **key** | **type** | **pattern** |
| --- | --- | --- |
| type | string | &#39;success&#39; | &#39;timeout&#39; | &#39;max\_tries&#39; | &#39;reset&#39; | &#39;error&#39; |

This message is sent to the module which _set_ the secret code.

Parameters

_type_:

_&#39;success&#39;_: The code was entered successfully by the user within the time and try constraint.

_&#39;timeout&#39;_: The code was not entered by the user within the time constraint.

_&#39;max\_tries&#39;_: The code was not entered by the user within the maximum number of tries.

_&#39;reset&#39;_: The code was not entered by the user before a reset message arrived.

_&#39;error&#39;_: The module encountered an unexpected error. This can be due to bad formatting of the &#39;set&#39; message.

### Example

A possible scenario would be that a person has to discover the murderer of a crime scene. To get some more information, he/she has to dial the correct number to get information from the coroner. When the code/digital phone number is correct, he/she will get the new clue. Which is a new module.

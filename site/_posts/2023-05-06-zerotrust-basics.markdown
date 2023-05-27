---
layout: single
title:  "What is Zero Trust"
date:   2023-05-06 13:54:15 +0200
categories: zero-trust
tag: zero-trust
author_profile: true
classes: wide
share: true
---

<h2>The principles</h2>

**Verify explicitly**

**Least privilege access**

**Assume breach**

<h2>The approach</h2>
The five steps to approach Zero Trust.

1. Define the protect surface. Break down your environment into smaller pieces that you need to protect.
2. Map the transaction flows. Investigate dependencies, inbound and outbound connections and how data flows through the network.
3. Architect a Zero Trust environment. Use the Zero Trust principles to design an architecture to protect your protect surface.
4. Create Zero Trust security policies. Use the Kipling method (who, what, when, where, why, how) to develop security policies.
5. Monitor and maintain. Monitor signals to detect any risks, remediate risks and improve the Zero Trust Architecture and security policies.

<h2>The hotel analogy</h2>

<div>
<img src="/assets/images/hotel-building.jpg" class="align-left" width="250" />
The example of physical building is a perfect example to explain the principles of the Zero Trust security model. The security measures that we take in real life can be applied to the digital world as well. The things we do in the real world feels normal and standard, but in the digital world, we often forget to apply the same principles.
</div>

<hr />

<img src="/assets/images/hotel-building.jpg" class="align-right" width="250" />
As the guests approach the luxurious hotel, they drive up to the barriers where they request access from the reception. Once granted access, they park their vehicles in the garage and make their way to the reception area to check in. The friendly receptionist greets them and requests identification in the form of a passport or driver's license. After swift verification, the guest is asked to fill out necessary information, including their license plate number which is registered to their name.
Once all formalities are completed, the guest is given an access card which is the key to their hotel room and all the amazing facilities that the hotel has to offer, such as the swimming pool, wellness center, and gym. All card activity is stored in a central database, ensuring the safety and security of the guests during their stay.
<hr />

<img src="/assets/images/hotel-building.jpg" class="align-left" width="250" />
The hotel understands that the safety and security of guests' belongings is of utmost importance. That's why each hotel room is equipped with a safe that is reset once a new guest arrives. This ensures that the safe is completely secure and ready for the incoming guest to set up their own personal code. Guests can configure the safe with a personal code, which only they know, providing them with complete peace of mind that their valuable belongings are protected. The safe can only be opened using this code, making it impossible for anyone else to access the contents of the safe. While the cleaners have access to the room to ensure it is kept clean and tidy, they are unable to open the safe. This means that guests can relax and enjoy their stay, knowing that their personal belongings are completely safe and secure. (edited) 

<h3>Verify explicitly</h3>
<img src="/assets/images/hotel-building.jpg" class="align-right" width="250" />
Guests arrive at the hotel by car and stop at the barriers to request access from the reception. After parking in the garage, guests walk to the reception to check in. The receptionist asks for identification in the form of a passport or driver's license. After verification, the guest is asked to fill out necessary information, including their license plate number which is registered to their name. Once the check-in process is complete, the guest receives an access card which provides entry to their hotel room and facilities, such as the swimming pool, wellness center, and gym. All card activity is stored in a central database.

<h3>Least privilege access</h3>
<img src="/assets/images/hotel-building.jpg" class="align-left" width="250" />

When you want to go for a swim, you need to bring your access card. You must swipe the card against the lock to gain access. You only have access to your own room and cannot enter any other rooms. For example, if your room number is 300, you only have access to that specific room in the hotel. You cannot access room 300 in a different hotel.

Hotel guests want to secure their valuable belongings safely in the hotel room. Each hotel room contains a safe that is reset once a new guest arrives. The guest can configure the safe with a personal code and only they can open it using this code. Cleaners have access to the room but cannot open the saf


Hotel rooms are cleaned every day between 10:00 and 14:00. Cleaners are provided with access cards that allow them to enter each hotel room. These cards are linked to the cleaners, so the hotel knows who enters each room and when. The cards are activated between 10:00 and 14:00; outside these hours, access is revoked. All card operations are stored in the database, which allows the hotel to keep track of who entered each room, when they did so, and for how long. 

The hotel guest uses the same card to access both their room and other facilities. Each time a guest uses their card, whether to open their room or another facility, the operation is stored in the database. The same applies to the access card of a cleaner. The security department monitors the signals of access cards. If an unusual event occurs, for example, if a cleaner's card is used to enter a hotel room in the middle of the night, then security takes action

The hotel is responsible for providing safety and security for its guests. To achieve this, the hotel is monitored 24/7. Smoke detectors are installed throughout the building to detect fires, and sprinklers are also in place to immediately mitigate any fires. Motion sensors are installed to trigger alarms. Security cameras monitor for any intruders or abnormal behavior, and guards are ready to take action if needed.

<h3>Assume breach</h3>
<img src="/assets/images/hotel-building.jpg" class="align-right" width="250" />
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec euismod, nisl eget fermentum aliquam, odio nibh ultricies nunc, quis ultricies nisl nunc quis nunc. Donec euismod, nisl eget fermentum aliquam, odio nibh ultricies nunc, quis ultricies nisl nunc quis nunc. Donec euismod, nisl eget fermentum aliquam, odio nibh ultricies nunc, quis ultricies nisl nunc quis nunc. Donec euismod, nisl eget fermentum aliquam, odio nibh ultricies nunc, quis ultricies nisl nunc quis nunc. Donec euismod, nisl eget fermentum aliquam, odio nibh ultricies nunc, quis ultricies nisl nunc quis nunc. Donec euismod, nisl eget fermentum aliquam, odio nibh ultricies nunc, quis ultricies nisl nunc quis nunc.

<h2>The SmartMoney demo</h2>
I will showcase how to implement the Zero Trust principles and approach in a real-world scenario through the [SmartMoney demo]({% link smartmoney.html %}). 
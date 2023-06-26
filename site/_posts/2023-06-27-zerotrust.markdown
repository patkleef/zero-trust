---
layout: single
title:  "Zero Trust"
date:   2023-06-27 08:54:15 +0200
categories: zero-trust
tags: zero-trust
author_profile: true
classes: wide
share: true
show_date: true
---
Zero Trust is a security model based on the "Never trust, Always verify" principle. This means that all users, devices, and applications must be verified before they are granted access. Zero Trust is not a product that can be purchased but rather a strategy for securing networks, infrastructure, data and applications. However, some products, such as Azure, can be used to follow the principles of Zero Trust. John Kindervag developed the security model in 2010, but it took almost a decade before the industry started to embrace it. This was due to a combination of factors, including a shift to mobile and cloud solutions and the professionalization of cybercrime. The Zero Trust model is now widely accepted and used by many organizations and governments.

<p class="notice--info">
    After the SolarWinds hack, the US government decided to adopt the Zero Trust security model. In May 2021, President Joe Biden signed an executive order that enforced federated agencies to apply the principles of Zero Trust.
</p>

Traditionally, we would build a perimeter around our network and trust everything inside the perimeter. Simply said placing a firewall in front of the network and implicit trust everything inside the network. This is no longer a viable option, as the perimeter is no longer well-defined. With the rise of cloud computing, mobile devices, and remote work, the perimeter has become more fluid. The Zero Trust model assumes that there are malicious actors both inside and outside the network. Therefore, we must verify every identity, regardless of whether the request comes from inside or outside the network.

Each application has different requirements and needs. Therefore, we must understand the application and its dependencies before we can design a Zero Trust architecture. We must also understand the data that the application uses and how it flows through the network. This is why we must break down the environment into smaller pieces that we need to protect. We call this the protect surface.

<h2>The principles</h2>

**Verify explicitly**
<p>The traditional security model relied on implicit trust, assuming everything on the network was safe and anyone inside the network had unrestricted access. However, this assumption is outdated, and we can no longer rely on the idea that everything is safe behind the firewall. With Zero Trust, we verify every identity, regardless of whether the request comes from inside or outside the network. We aim to authenticate and authorize all data points, as Zero Trust assumes that bad actors can be found everywhere, including inside your organization.</p>

**Least privilege access**
<p>Instead of granting sweeping access to identities, Zero Trust principles dictate that we should provide the least privileged access. Use Identity Access Management (IAM) to assign an identity only the minimal access rights required to complete an operation. In many cases, it is not necessary to give an identity permanent access, especially when dealing with highly privileged access. Instead, use Just-In-Time (JIT) and Just-Enough-Access (JEA) mechanisms.</p>

**Assume breach**
<p>Assume that there are malicious actors on the network and take steps to protect resources accordingly. When dealing with a hack, minimizing the blast radius is important. One way to achieve this is to isolate workloads as much as possible through network segmentation. However, be careful to keep your architecture simple, as complexity can introduce additional security risks.</p>

<h2>The five steps methodology</h2>

1. Define the protect surface. Break down your environment into smaller pieces that you need to protect e.g. intranet, corporate website, HR system, etc.
2. Map the transaction flows. Investigate dependencies, inbound and outbound connections and how data flows through the application and network.
3. Architect a Zero Trust environment. Use the Zero Trust principles to design an architecture to protect your protect surface.
4. Create Zero Trust security policies. Use the Kipling method (who, what, when, where, why, how) to develop security policies.
5. Monitor and maintain. Monitor signals to detect any risks, remediate risks and improve the Zero Trust Architecture and security policies.

<h2>The hotel analogy</h2>

<section class="page__content__section">
    <img src="/assets/images/hotel-building.jpg" class="align-left" width="250" />
    The example of physical building is a perfect example to explain the principles of Zero Trust. The security measures that we take in real life can be applied to the digital world as well. The things we do in the real world feels normal and standard, but in the digital world, we often forget to apply the same principles.
</section>
<hr />

<section class="page__content__section">
    <img src="/assets/images/receptionist.jpg" class="align-right" width="250" />
    As the guests approach the luxurious hotel, they drive up to the barriers where they request access from the reception. Once granted access, they park their vehicles in the garage and make their way to the reception area to check in. The friendly receptionist greets them and requests identification in the form of a passport or driver's license. After verification, the guest is asked to fill out necessary information, including their license plate number which is registered to their name.
    Once all formalities are completed, the guest is given an access card which is the key to their hotel room. The card only gives them access to their own room.
    <ul>
        <li>Each arriving guest is <strong>verified explicitly</strong> before granted access to the hotel (room).</li>
    </ul>
</section>
<hr />

<section class="page__content__section">
    <img src="/assets/images/hotel-safe.jpg" class="align-left" width="250" />
    The hotel understands that the safety and security of guests' belongings is of utmost importance. That's why each hotel room is equipped with a safe that is reset once a new guest arrives. This ensures that the safe is completely secure and ready for the incoming guest to set up their own personal code. Guests can configure the safe with a personal code, which only they know, providing them with complete peace of mind that their valuable belongings are protected. The safe can only be opened using this code, making it impossible for anyone else to access the contents of the safe. While the cleaners have access to the room to ensure it is kept clean and tidy, they are unable to open the safe.
    <ul>
        <li>A hotel <strong>assumes breach</strong> by placing a safe into each room. If an intruder manages to get access to the room, the safe will protect the guest's belongings.</li>
    </ul>
</section>
<hr />


<section class="page__content__section">
    <img src="/assets/images/hotel-guest.jpg" class="align-right" width="250" />
    As a hotel guest, one can only use their card to access their own room and shared amenities such as the swimming pool and gym. Access to other guest rooms or employee-only areas of the hotel is strictly prohibited. The guest's card is programmed to grant access only to authorized areas, ensuring maximum security and privacy for all guests. So, guests can rest easy knowing that their personal space and belongings are protected from unwanted intrusions.
    <ul>
        <li>A hotel follows the concept of <strong>least privileged access</strong> by allowing guests only access to their room. Guests can't use their card to access any other room.</li>
    </ul>
</section>
<hr />


<section class="page__content__section">
    <img src="/assets/images/hotel-cleaner.jpg" class="align-left" width="250" />
    The hotel staff takes great pride in maintaining a high level of cleanliness and hygiene in each guest room. To accomplish this, the rooms are cleaned every day between 10:00 and 14:00 by the dedicated team of cleaners. These cleaners are provided with access cards that enable them to enter each hotel room with ease. The cards are specifically linked to the cleaners, allowing the hotel to keep a record of who enters each room and at what time. The cards are programmed to activate only between the designated cleaning hours, and access is revoked outside these hours. All card operations are stored in the database, enabling the hotel to keep track of who entered each room, when they did so, and for how long. 
    <ul>
        <li>Cleaners only have access to rooms during specific time - <strong>least privileged access</strong>.</li>
    </ul>
</section>
<hr />

<section class="page__content__section">
    <img src="/assets/images/hotel-smoke.jpg" class="align-right" width="250" />
    Ensuring the safety and security of its guests is the top priority of the hotel management. To achieve this, the hotel is under constant surveillance 24/7. The building is equipped with smoke detectors that are strategically placed to detect any signs of fire. In the event of a fire, sprinklers are installed to mitigate the situation immediately. Motion sensors are installed throughout the premises to trigger alarms in case of any suspicious activity. Security cameras are also placed strategically to monitor for any potential intruders or abnormal behavior. To further strengthen the security measures, guards are always on standby, ready to take swift action if needed. With these comprehensive safety measures in place, the guests can enjoy their stay with peace of mind, knowing that their safety is the hotel's top priority.
    <ul>
        <li><strong>Signals</strong> are monitored to detect any risks</li>
    </ul>
</section>

<h2>The SmartMoney demo</h2>
I will showcase how to implement the Zero Trust principles and approach in a real-world scenario through the [SmartMoney demo]({% link smartmoney.html %}). 
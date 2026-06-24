export const site = {
  brand: "Mulu Caves",
  tagline: "Gunung Mulu National Park · Sarawak",
  domain: "mulucaves.com",

  hero: {
    issue:   "Issue No. 1 · Sarawak, Borneo",
    title:   "Where the rainforest meets the world's largest caves.",
    subtitle:
      "A field journal of place — four signature experiences in a UNESCO World Heritage Site, recorded for the slow traveller.",
    byline:  "Words & curation · The Mulu Field Office",
    cta:     { text: "Begin the journey", href: "#park" },
    chapters: [
      { num: "01", label: "The Park" },
      { num: "02", label: "Experiences" },
      { num: "03", label: "Where to stay" },
      { num: "04", label: "Inquire" },
    ],
  },

  park: {
    numeral: "§01",
    eyebrow: "Chapter One",
    title: "A cathedral *older* than memory.",
    pull:
      "“A walk into Deer Cave is a walk into a scale of nature we have forgotten how to read.”",
    body: [
      "Gunung Mulu rises in the north-eastern corner of Sarawak, draped in primary rainforest that has never felt a road. The park holds some of the largest cave passages on Earth — Deer Cave alone is taller than the Statue of Liberty and wide enough to fly a small aircraft through.",
      "It is also home to the Pinnacles: a forest of razor limestone spires that climb forty-five metres above the canopy. They are not climbed without a guide, and they are not forgotten once seen.",
    ],
    meta: [
      { k: "Established",    v: "1985" },
      { k: "Heritage",       v: "UNESCO, 2000" },
      { k: "Area",           v: "528 km²" },
      { k: "Coordinates",    v: "4.05° N · 114.92° E" },
    ],
  },

  experiences: {
    numeral: "§02",
    eyebrow: "Chapter Two",
    title: "Four ways to spend a *slow* week.",
    items: [
      {
        n: "01",
        name: "Deer Cave at dusk",
        body:
          "Walk the plank walk beneath one of the world's largest cave passages. Stay for the bat exodus — millions of wrinkle-lipped bats streaming into the dusk in a ribbon against the copper sky.",
        meta: "Half-day · easy",
      },
      {
        n: "02",
        name: "The Canopy Skywalk",
        body:
          "Suspended twenty metres above the rainforest, the 480-metre skywalk rewards the steady-footed with a bird's-eye view of rivers of green that have not known a road in seven thousand years.",
        meta: "Two hours · moderate",
      },
      {
        n: "03",
        name: "Headhunter's Trail",
        body:
          "A guided jungle trek along a path once used by the Penan people. Three days, two rivers, one hot spring — and the cultural memory of a long, careful inhabitation.",
        meta: "Three days · strenuous",
      },
      {
        n: "04",
        name: "River cruise, twilight",
        body:
          "A flat-bottomed boat along the Melinau at the hour when hornbills come in to roost. Bring a long lens and a quiet voice.",
        meta: "Evening · easy",
      },
    ],
  },

  stay: {
    numeral: "§03",
    eyebrow: "Chapter Three",
    title: "Where to *lay* your head.",
    intro:
      "Four places, in order of closeness to the caves. Pick your pace — full resort, mid-range lodge, park-run hostel, or quiet homestay.",
    items: [
      {
        n: "I",
        name: "Mulu Marriott Resort & Spa",
        body: "Full-service resort with rainforest views, a swimming pool, and a tour desk that handles every park permit you will need.",
        from: "MYR 480 / night",
      },
      {
        n: "II",
        name: "Royal Mulu Resort",
        body: "Comfortable mid-range lodge within walking distance of park headquarters. Air-conditioned rooms and a reliable kitchen.",
        from: "MYR 280 / night",
      },
      {
        n: "III",
        name: "Mulu National Park Hostel",
        body: "Affordable dorm rooms run by Sarawak Forestry. The closest beds to the caves — and the quietest mornings you will have this year.",
        from: "MYR 75 / night",
      },
      {
        n: "IV",
        name: "Benarat Inn",
        body: "A small guesthouse catering to independent travellers. Simple rooms, a long veranda, conversations with the gardener over coffee.",
        from: "MYR 120 / night",
      },
    ],
  },

  inquire: {
    numeral: "§04",
    eyebrow: "Chapter Four",
    title: "Tell us *how* you travel.",
    body:
      "We read every inquiry by hand. Expect a reply within two working days, written by a person who has walked the plank walk this season.",
    cta: { text: "Send an inquiry →", href: "http://localhost:8080/mulu-caves/inquiry" },
    note: "Or write to us directly at field@mulucaves.com",
  },

  footer: {
    colophon:
      "Set in Cormorant Garamond & Plus Jakarta Sans. Composed as a one-page editorial for the slow traveller to Sarawak.",
    address: ["Mulu Field Office", "Sarawak, Malaysia", "4.05° N · 114.92° E"],
    sections: [
      {
        title: "Read",
        items: [
          { label: "The Park",        href: "#park" },
          { label: "Experiences",     href: "#experiences" },
          { label: "Where to stay",   href: "#stay" },
          { label: "Inquire",         href: "#inquire" },
        ],
      },
      {
        title: "Beyond",
        items: [
          { label: "UNESCO listing",    href: "https://whc.unesco.org/en/list/1013", external: true },
          { label: "Sarawak Forestry",  href: "https://www.sarawakforestry.com",     external: true },
          { label: "On Google Maps",    href: "https://maps.google.com/?q=Mulu+Caves+Sarawak+Malaysia", external: true },
        ],
      },
    ],
  },
} as const;
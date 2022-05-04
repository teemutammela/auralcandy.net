module.exports = function (migration) {
  const episode = migration
    .createContentType("episode")
    .name("Episode")
    .description("Podcast episode item")
    .displayField("title");

  episode
    .createField("dj")
    .name("DJ")
    .type("Array")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false)
    .items({
      type: "Link",

      validations: [
        {
          linkContentType: ["author"],
          message: "Invalid relation. Only DJ is allowed.",
        },
      ],

      linkType: "Entry",
    });

  episode
    .createField("title")
    .name("Title")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
    ])
    .disabled(false)
    .omitted(false);

  episode
    .createField("slug")
    .name("Slug")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
      {
        size: {
          max: 255,
        },

        message: "Should be less than 255 characters",
      },
      {
        regexp: {
          pattern: "^[a-z0-9-]*$",
          flags: "i",
        },

        message: "Only lowercase characters, numbers and hyphens are allowed.",
      },
    ])
    .disabled(false)
    .omitted(false);

  episode
    .createField("releaseDate")
    .name("Release Date")
    .type("Date")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false);

  episode
    .createField("brand")
    .name("Brand")
    .type("Link")
    .localized(false)
    .required(true)
    .validations([
      {
        linkContentType: ["brand"],
        message: "Invalid relation. Only Brand is allowed.",
      },
    ])
    .disabled(false)
    .omitted(false)
    .linkType("Entry");

  episode
    .createField("description")
    .name("Description")
    .type("Text")
    .localized(false)
    .required(false)
    .validations([])
    .disabled(false)
    .omitted(false);
  episode
    .createField("trackList")
    .name("Track List")
    .type("Text")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false);

  episode
    .createField("duration")
    .name("Duration")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        regexp: {
          pattern: "^\\d{2}:\\d{2}:\\d{2}$",
          flags: "",
        },

        message: "Should be of format HH:MM:SS",
      },
    ])
    .disabled(false)
    .omitted(false);

  episode
    .createField("genre")
    .name("Genre")
    .type("Array")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false)
    .items({
      type: "Symbol",

      validations: [
        {
          in: [
            "Acid House",
            "Acid Jazz",
            "Alternative",
            "Ambient",
            "Audio Drama",
            "Beach House",
            "Big Beat",
            "Chill Out",
            "Deep House",
            "Drum & Bass",
            "Electro House",
            "Funk & Soul",
            "Funky House",
            "Garage",
            "Hip-Hop",
            "House Music",
            "Latin House",
            "Nu-Disco",
            "Other",
            "Progressive House",
            "Psytrance",
            "Soulful House",
            "Tech House",
            "Techno",
            "Trance",
            "Tribal House",
            "Trip-Hop",
            "World Music",
          ],

          message: "Not included in allowed genres",
        },
      ],
    });

  episode
    .createField("label")
    .name("Label")
    .type("Array")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false)
    .items({
      type: "Link",

      validations: [
        {
          linkContentType: ["label"],
          message: "Invalid relation. Only Label is allowed.",
        },
      ],

      linkType: "Entry",
    });

  episode
    .createField("image")
    .name("Image")
    .type("Link")
    .localized(false)
    .required(false)
    .validations([
      {
        linkMimetypeGroup: ["image"],
        message: "Invalid file type. Only image is allowed.",
      },
      {
        assetImageDimensions: {
          width: {
            min: 900,
            max: null,
          },

          height: {
            min: 900,
            max: null,
          },
        },

        message: "Invalid dimensions. Should be at least 900 x 900 pixels.",
      },
    ])
    .disabled(false)
    .omitted(false)
    .linkType("Asset");

  episode
    .createField("audio")
    .name("Audio")
    .type("Link")
    .localized(false)
    .required(true)
    .validations([
      {
        linkMimetypeGroup: ["audio"],
        message: "Invalid file type. Only audio is allowed.",
      },
    ])
    .disabled(false)
    .omitted(false)
    .linkType("Asset");

  episode
    .createField("downloads")
    .name("Downloads")
    .type("Integer")
    .localized(false)
    .required(false)
    .validations([
      {
        range: {
          min: 0,
          max: 999999,
        },
      },
    ])
    .disabled(false)
    .omitted(false);

  episode.changeFieldControl("dj", "builtin", "entryLinksEditor", {
    helpText: "Multiple DJs are formatted as 'First, Second & Third'",
    bulkEditing: false,
    showLinkEntityAction: true,
    showCreateEntityAction: false,
  });

  episode.changeFieldControl("title", "builtin", "singleLine", {
    helpText: "e.g. 'Awesome Deep House Mix. Vol. 01'",
  });

  episode.changeFieldControl("slug", "builtin", "slugEditor", {
    helpText: "e.g. 'awesome-deep-house-mix-vol01'",
  });

  episode.changeFieldControl("releaseDate", "builtin", "datePicker", {
    format: "dateonly",
    helpText: "Only affects display order, NOT a scheduled publishing tool.",
  });

  episode.changeFieldControl("brand", "builtin", "entryLinkEditor", {
    helpText: "",
    showLinkEntityAction: true,
    showCreateEntityAction: false,
  });

  episode.changeFieldControl("description", "builtin", "markdown", {
    helpText:
      "Brand's field 'Long description' is used as fallback if episode has no description",
  });

  episode.changeFieldControl("trackList", "builtin", "markdown", {
    helpText:
      "Format 'Producer feat. Vocalist - Track Name [Mix Name]' per line",
  });

  episode.changeFieldControl("duration", "builtin", "singleLine", {
    helpText: "HH:MM:SS",
  });

  episode.changeFieldControl("genre", "builtin", "checkbox", {
    helpText: "",
  });

  episode.changeFieldControl("label", "builtin", "entryLinksEditor", {
    bulkEditing: true,
  });

  episode.changeFieldControl("image", "builtin", "assetLinkEditor", {
    helpText:
      "Brand's field 'Image' is used as fallback if episode has no image",
    showLinkEntityAction: true,
    showCreateEntityAction: false,
  });

  episode.changeFieldControl("audio", "builtin", "assetLinkEditor", {
    helpText: "Recommended audio file type MP3, AAC or WMA.",
    showLinkEntityAction: true,
    showCreateEntityAction: false,
  });

  episode.changeFieldControl("downloads", "builtin", "numberEditor", {
    helpText: "Updated automatically; Do not edit manually.",
  });

  const brand = migration
    .createContentType("brand")
    .name("Brand")
    .description("Podcast brand")
    .displayField("name");

  brand
    .createField("name")
    .name("Name")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
    ])
    .disabled(false)
    .omitted(false);

  brand
    .createField("default")
    .name("Default")
    .type("Boolean")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false);

  brand
    .createField("slug")
    .name("Slug")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
      {
        size: {
          max: 255,
        },

        message: "Should be less than 255 characters.",
      },
      {
        regexp: {
          pattern: "^[a-z0-9-]*$",
          flags: "i",
        },
      },
    ])
    .disabled(false)
    .omitted(false);

  brand
    .createField("tagline")
    .name("Tagline")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false);

  brand
    .createField("image")
    .name("Image")
    .type("Link")
    .localized(false)
    .required(true)
    .validations([
      {
        linkMimetypeGroup: ["image"],
        message: "Invalid relation. Only images are allowed.",
      },
      {
        assetImageDimensions: {
          width: {
            min: 900,
            max: null,
          },

          height: {
            min: 900,
            max: null,
          },
        },

        message: "Invalid dimensions. Should be at least 900 x 900 pixels.",
      },
    ])
    .disabled(false)
    .omitted(false)
    .linkType("Asset");

  brand
    .createField("shortDescription")
    .name("Short Description")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        size: {
          max: 140,
        },

        message: "Should be less than 140 characters",
      },
    ])
    .disabled(false)
    .omitted(false);

  brand
    .createField("longDescription")
    .name("Long Description")
    .type("Text")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false);
  brand
    .createField("compatibility")
    .name("Compatibility")
    .type("Text")
    .localized(false)
    .required(false)
    .validations([])
    .disabled(false)
    .omitted(false);
  brand
    .createField("privacyPolicy")
    .name("Privacy Policy")
    .type("Text")
    .localized(false)
    .required(false)
    .validations([])
    .disabled(false)
    .omitted(false);

  brand
    .createField("keywords")
    .name("Keywords")
    .type("Array")
    .localized(false)
    .required(true)
    .validations([])
    .disabled(false)
    .omitted(false)
    .items({
      type: "Symbol",
      validations: [],
    });

  brand
    .createField("email")
    .name("E-Mail")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        regexp: {
          pattern: "^\\w[\\w.-]*@([\\w-]+\\.)+[\\w-]+$",
        },

        message: "Is not a valid e-mail address",
      },
    ])
    .disabled(false)
    .omitted(false);

  brand
    .createField("phone")
    .name("Phone")
    .type("Symbol")
    .localized(false)
    .required(false)
    .validations([
      {
        size: {
          max: 20,
        },

        message: "Should be less than 20 characters",
      },
    ])
    .disabled(false)
    .omitted(false);

  brand
    .createField("streetAddress")
    .name("Street Address")
    .type("Symbol")
    .localized(false)
    .required(false)
    .validations([])
    .disabled(false)
    .omitted(false);

  brand
    .createField("zipCode")
    .name("Zip Code")
    .type("Symbol")
    .localized(false)
    .required(false)
    .validations([
      {
        size: {
          min: 5,
          max: 5,
        },

        message: "Should be 5 characters long",
      },
    ])
    .disabled(false)
    .omitted(false);

  brand
    .createField("locality")
    .name("Locality")
    .type("Symbol")
    .localized(false)
    .required(false)
    .validations([])
    .disabled(false)
    .omitted(false);

  brand
    .createField("navigationMenu")
    .name("Navigation Menu")
    .type("Array")
    .localized(false)
    .required(true)
    .validations([
      {
        size: {
          max: 8,
        },

        message: "Should be no more than 8 items",
      },
    ])
    .disabled(false)
    .omitted(false)
    .items({
      type: "Link",

      validations: [
        {
          linkContentType: ["navigationAnchor", "navigationLink"],
          message:
            "Invalid relation. Only Navigation Anchor or Navigation Link is allowed.",
        },
      ],

      linkType: "Entry",
    });

  brand.changeFieldControl("name", "builtin", "singleLine", {
    helpText: "e.g. 'AuralCandy.Net'",
  });

  brand.changeFieldControl("default", "builtin", "boolean", {
    helpText: "Only one brand should be set as default",
    trueLabel: "Yes",
    falseLabel: "No",
  });

  brand.changeFieldControl("slug", "builtin", "slugEditor", {
    helpText: "e.g. 'auralcandynet'",
  });

  brand.changeFieldControl("tagline", "builtin", "singleLine", {
    helpText: "e.g. 'Premium House Music Podcast'",
  });

  brand.changeFieldControl("image", "builtin", "assetLinkEditor", {
    helpText:
      "Minimum required dimensions 900 x 900 pixels. Square image recommended.",
    showLinkEntityAction: true,
    showCreateEntityAction: false,
  });

  brand.changeFieldControl("shortDescription", "builtin", "singleLine", {
    helpText:
      "Displayed in the header section of index page, Google search results etc.",
  });

  brand.changeFieldControl("longDescription", "builtin", "markdown", {
    helpText: "Displayed in the footer section of page, RSS feed etc.",
  });

  brand.changeFieldControl("compatibility", "builtin", "markdown", {
    helpText: "Displayed in the header section of index page",
  });

  brand.changeFieldControl("privacyPolicy", "builtin", "markdown", {
    helpText:
      "Displayed in the footer section of page. Needed only for the default brand.",
  });

  brand.changeFieldControl("keywords", "builtin", "tagEditor", {
    helpText: "e.g. 'Podcast', 'DJ' and 'House Music'",
  });

  brand.changeFieldControl("email", "builtin", "singleLine", {
    helpText: "Displayed in the footer section of the page",
  });

  brand.changeFieldControl("phone", "builtin", "singleLine", {
    helpText: "Displayed in the footer section of the page",
  });

  brand.changeFieldControl("streetAddress", "builtin", "singleLine", {
    helpText: "Displayed in the footer section of the page",
  });

  brand.changeFieldControl("zipCode", "builtin", "singleLine", {
    helpText: "Displayed in the footer section of the page",
  });

  brand.changeFieldControl("locality", "builtin", "singleLine", {
    helpText: "Displayed in the footer section of the page",
  });

  brand.changeFieldControl("navigationMenu", "builtin", "entryLinksEditor", {
    helpText:
      "Order of items matches order of links and anchors on navigation menu",
    bulkEditing: true,
    showLinkEntityAction: true,
    showCreateEntityAction: true,
  });

  const navigationLink = migration
    .createContentType("navigationLink")
    .name("Navigation Link")
    .description("Navigation menu internal or external URL")
    .displayField("name");

  navigationLink
    .createField("name")
    .name("Name")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
      {
        size: {
          max: 25,
        },

        message: "Should be no more than 25 characters",
      },
    ])
    .disabled(false)
    .omitted(false);

  navigationLink
    .createField("description")
    .name("Description")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        size: {
          max: 75,
        },

        message: "Should be no more than 75 characters",
      },
    ])
    .disabled(false)
    .omitted(false);

  navigationLink
    .createField("linkUrl")
    .name("Link URL")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
      {
        size: {
          max: 255,
        },

        message: "Should no more than 255 characters",
      },
      {
        regexp: {
          pattern:
            "^(http|https):\\/\\/(\\w+:{0,1}\\w*@)?(\\S+)(:[0-9]+)?(\\/|\\/([\\w#!:.?+=&%@!\\-/]))?$",
          flags: "i",
        },

        message: "Not a valid URL",
      },
    ])
    .disabled(false)
    .omitted(false);

  navigationLink.changeFieldControl("name", "builtin", "singleLine", {
    helpText: "Visible navigation menu link (e.g 'Apple Podcasts')",
  });

  navigationLink.changeFieldControl("description", "builtin", "singleLine", {
    helpText:
      "Navigation menu link extended description (e.g. 'Listen on Apple Podcasts')",
  });

  navigationLink.changeFieldControl("linkUrl", "builtin", "urlEditor", {});
  const navigationAnchor = migration
    .createContentType("navigationAnchor")
    .name("Navigation Anchor")
    .description("Navigation menu in-page anchor")
    .displayField("name");

  navigationAnchor
    .createField("name")
    .name("Name")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
      {
        size: {
          max: 25,
        },

        message: "Should be no more than 25 characters",
      },
    ])
    .disabled(false)
    .omitted(false);

  navigationAnchor
    .createField("description")
    .name("Description")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        size: {
          max: 75,
        },

        message: "Should be no more than 75 characters",
      },
    ])
    .disabled(false)
    .omitted(false);

  navigationAnchor
    .createField("linkAnchor")
    .name("Link Anchor")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
      {
        size: {
          max: 75,
        },

        message: "Should be no more than 75 characters",
      },
      {
        regexp: {
          pattern: "^#[a-z-]{1,75}$",
          flags: "i",
        },

        message: "Not a valid anchor",
      },
    ])
    .disabled(false)
    .omitted(false);

  navigationAnchor.changeFieldControl("name", "builtin", "singleLine", {
    helpText: "Visible navigation menu anchor (e.g 'Contact')",
  });

  navigationAnchor.changeFieldControl("description", "builtin", "singleLine", {
    helpText:
      "Navigation menu anchor extended description (e.g. 'Contact Us via E-mail or Phone')",
  });

  navigationAnchor.changeFieldControl("linkAnchor", "builtin", "singleLine", {
    helpText: "Target element ID (e.g. '#contact')",
  });

  const author = migration
    .createContentType("author")
    .name("DJ")
    .description("Author of a podcast episode")
    .displayField("handle");

  author
    .createField("handle")
    .name("Handle")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
    ])
    .disabled(false)
    .omitted(false);

  author
    .createField("name")
    .name("Name")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
    ])
    .disabled(false)
    .omitted(false);

  author.changeFieldControl("handle", "builtin", "singleLine", {
    helpText: "e.g. 'MK-Ultra'",
  });

  author.changeFieldControl("name", "builtin", "singleLine", {
    helpText: "Firstname Lastname",
  });

  const label = migration
    .createContentType("label")
    .name("Label")
    .description("Related recording label")
    .displayField("name");

  label
    .createField("name")
    .name("Name")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
    ])
    .disabled(false)
    .omitted(false);

  label
    .createField("linkUrl")
    .name("Link URL")
    .type("Symbol")
    .localized(false)
    .required(true)
    .validations([
      {
        unique: true,
      },
      {
        regexp: {
          pattern:
            "^(http|https):\\/\\/(\\w+:{0,1}\\w*@)?(\\S+)(:[0-9]+)?(\\/|\\/([\\w#!:.?+=&%@!\\-\\/]))?$",
          flags: "i",
        },

        message: "Not a valid URL",
      },
    ])
    .disabled(false)
    .omitted(false);

  label.changeFieldControl("name", "builtin", "singleLine", {
    helpText: "Name of the recording label (e.g. 'Defected Records')",
  });

  label.changeFieldControl("linkUrl", "builtin", "urlEditor", {});
};

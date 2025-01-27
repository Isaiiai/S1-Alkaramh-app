final List<Map<String, dynamic>> testData = [
  {
    "PRODUCT": {
      "id": "1",
      "category_id": "CAT01",
      "name": "Wheat Straw - 6kg",
      "description":
          "High-quality wheat straw perfect for animal bedding or feeding.",
      "images": "https://example.com/images/wheat_straw.jpg",
      "is_active": true,
      "created_at": "2025-01-01T10:00:00Z",
      "updated_at": "2025-01-05T15:30:00Z"
    },
    "PRODUCT_VARIANT": {
      {
        "id": "1",
        "name": "5kg",
        "price": 10.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "2",
        "name": "12kg",
        "price": 30.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "3",
        "name": "18kg",
        "price": 45.0,
        "discounted_price": 12.0,
        "isAvailable": true
      }
    }
  },
  {
    "PRODUCT": {
      "id": "2",
      "category_id": "CAT02",
      "name": "Organic Fertilizer - 5kg",
      "description": "Natural fertilizer to boost crop growth and soil health.",
      "images": "https://example.com/images/fertilizer.jpg",
      "is_active": true,
      "created_at": "2025-01-02T11:00:00Z",
      "updated_at": "2025-01-06T16:30:00Z"
    },
    "PRODUCT_VARIANT": {
      {
        "id": "1",
        "name": "5kg",
        "price": 10.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "2",
        "name": "12kg",
        "price": 30.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "3",
        "name": "18kg",
        "price": 45.0,
        "discounted_price": 12.0,
        "isAvailable": true
      }
    }
  },
  {
    "PRODUCT": {
      "id": "3",
      "category_id": "CAT03",
      "name": "Corn Seeds - 1kg",
      "description": "Premium quality corn seeds with high germination rate.",
      "images": "https://example.com/images/corn_seeds.jpg",
      "is_active": true,
      "created_at": "2025-01-03T12:00:00Z",
      "updated_at": "2025-01-07T17:30:00Z"
    },
    "PRODUCT_VARIANT": {
      {
        "id": "1",
        "name": "5kg",
        "price": 10.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "2",
        "name": "12kg",
        "price": 30.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "3",
        "name": "18kg",
        "price": 45.0,
        "discounted_price": 12.0,
        "isAvailable": true
      }
    }
  },
  {
    "PRODUCT": {
      "id": "4",
      "category_id": "CAT04",
      "name": "Tractor Tire - 20 inch",
      "description": "Durable tractor tire for rough terrains.",
      "images": "https://example.com/images/tractor_tire.jpg",
      "is_active": true,
      "created_at": "2025-01-04T13:00:00Z",
      "updated_at": "2025-01-08T18:30:00Z"
    },
    "PRODUCT_VARIANT": {
      {
        "id": "1",
        "name": "5kg",
        "price": 10.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "2",
        "name": "12kg",
        "price": 30.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "3",
        "name": "18kg",
        "price": 45.0,
        "discounted_price": 12.0,
        "isAvailable": true
      }
    }
  },
  {
    "PRODUCT": {
      "id": "5",
      "category_id": "CAT05",
      "name": "Irrigation Pipe - 50m",
      "description":
          "Flexible irrigation pipe for efficient water distribution.",
      "images": "https://example.com/images/irrigation_pipe.jpg",
      "is_active": true,
      "created_at": "2025-01-05T14:00:00Z",
      "updated_at": "2025-01-09T19:30:00Z"
    },
    "PRODUCT_VARIANT": {
      {
        "id": "1",
        "name": "5kg",
        "price": 10.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "2",
        "name": "12kg",
        "price": 30.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "3",
        "name": "18kg",
        "price": 45.0,
        "discounted_price": 12.0,
        "isAvailable": true
      }
    }
  },
  {
    "PRODUCT": {
      "id": "6",
      "category_id": "CAT06",
      "name": "Garden Shovel",
      "description": "Sturdy garden shovel for all your gardening needs.",
      "images": "https://example.com/images/garden_shovel.jpg",
      "is_active": true,
      "created_at": "2025-01-06T15:00:00Z",
      "updated_at": "2025-01-10T20:30:00Z"
    },
    "PRODUCT_VARIANT": {
      {
        "id": "1",
        "name": "5kg",
        "price": 10.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "2",
        "name": "12kg",
        "price": 30.0,
        "discounted_price": 12.0,
        "isAvailable": true
      },
      {
        "id": "3",
        "name": "18kg",
        "price": 45.0,
        "discounted_price": 12.0,
        "isAvailable": true
      }
    }
  }
];

final List<Map<String, dynamic>> testCategoryData = [
  {
    "CATEGORY": {
      "id": "CAT01",
      "name": "Hay",
      "images": "https://example.com/images/agriculture_category.jpg",
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT02",
      "name": "Alfalfa",
     
      "images": "https://example.com/images/fertilizers_category.jpg",
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT03",
      "name": "Rodhes",
      "images": ["https://example.com/images/seeds_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT04",
      "name": "Mineral Salt",
      "images": ["https://example.com/images/tractor_parts_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT05",
      "name": "Dates",
      "images": ["https://example.com/images/irrigation_category.jpg"],
      "is_active": true
    }
  },
  
  
  {
    "CATEGORY": {
      "id": "CAT07",
      "name": "Firewood&charcol",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true,
    }
  },
  {
    "CATEGORY": {
      "id": "CAT06",
      "name": "Aalaf feed",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT06",
      "name": "Hen food",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT06",
      "name": "Millet",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT06",
      "name": "Mineral Salt",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT06",
      "name": "Corn",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT06",
      "name": "Alfalfa",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true
    }
  },
  {
    "CATEGORY": {
      "id": "CAT06",
      "name": "Alfalfa feed",
      "images": ["https://example.com/images/gardening_tools_category.jpg"],
      "is_active": true
    }
  },
];

//test data for the user
final List<Map<String, dynamic>> testUserData = [
  {
    "id": "1",
    "email": "johndoe@example.com",
    "phone": "1234567890",
    "hashed_password": "hashed_password_1",
    "name": "John Doe",
    "address": {
      "first_name": "John",
      "last_name": "Doe",
      "address": "123 Main St",
      "apartment": "Apt 1",
      "country": "USA",
      "city": "New York",
      "state": "NY",
      "zip": "10001"
    }
  }
];

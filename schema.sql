CREATE TABLE zikr_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL
);

CREATE TABLE zikr_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL,
    audio TEXT,
    repeat INTEGER NOT NULL
);

CREATE TABLE zikr_item_content (
    id INTEGER PRIMARY KEY,
    zikr_item_id INTEGER NOT NULL,
    text TEXT NOT NULL,
    -- Category is an enum of text, count, quran
    category TEXT NOT NULL CHECK (
        category IN (
            'text',
            'count',
            'quran',
            'foreword'
        )
    )
);
-- CreateTable
CREATE TABLE "Mission" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "application_url" TEXT
);

-- CreateTable
CREATE TABLE "Publisher" (
    "id" TEXT NOT NULL PRIMARY KEY
);

-- CreateTable
CREATE TABLE "Impression" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "mission_id" TEXT NOT NULL,
    "publisher_id" TEXT NOT NULL,
    CONSTRAINT "Impression_mission_id_fkey" FOREIGN KEY ("mission_id") REFERENCES "Mission" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Impression_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "Publisher" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Redirection" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "token" TEXT NOT NULL,
    "mission_id" TEXT NOT NULL,
    "publisher_id" TEXT NOT NULL,
    CONSTRAINT "Redirection_mission_id_fkey" FOREIGN KEY ("mission_id") REFERENCES "Mission" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Redirection_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "Publisher" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "MissionApplication" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "redirection_id" TEXT,
    "mission_id" TEXT NOT NULL,
    "publisher_id" TEXT NOT NULL,
    CONSTRAINT "MissionApplication_redirection_id_fkey" FOREIGN KEY ("redirection_id") REFERENCES "Redirection" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "MissionApplication_mission_id_fkey" FOREIGN KEY ("mission_id") REFERENCES "Mission" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "MissionApplication_publisher_id_fkey" FOREIGN KEY ("publisher_id") REFERENCES "Publisher" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "Redirection_token_key" ON "Redirection"("token");

-- CreateIndex
CREATE INDEX "Redirection_token_idx" ON "Redirection"("token");

from os import path, makedirs

# Configure the video directory
MEDIA_DIR = ""

def set_media_dir(dir_path):
    global MEDIA_DIR
    MEDIA_DIR = dir_path

# Global flag to disable authentication
NO_AUTH = False
def set_no_auth(value: bool):
    global NO_AUTH
    NO_AUTH = value

MEDIAS_BASE_DIR = "media_files"
THUMBNAIL_DIR = path.join(path.dirname(__file__), MEDIAS_BASE_DIR, "thumbnails")
PREVIEW_DIR = path.join(path.dirname(__file__), MEDIAS_BASE_DIR, "previews")

# Ensure directory exists
makedirs(THUMBNAIL_DIR, exist_ok=True)
makedirs(PREVIEW_DIR, exist_ok=True)

VIDEO_EXTS = ('.mp4', '.mov', '.webm')
IMAGE_EXTS = ('.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp')
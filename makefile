CXX = g++
CXXFLAGS = -std=c++17
SOURCES = cloud-backup.cpp
TARGET = cloud-backup

$(TARGET): $(SOURCES)
	$(CXX) $(CXXFLAGS) $^ -o $@

.PHONY: clean

clean:
	rm -f $(TARGET)
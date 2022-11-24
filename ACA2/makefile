TARGET_EXEC := GEN_CYCLE
RUNSHELL_NAME := run

BUILD_DIR := ./build
SRC_DIRS := ./src
#RESOURCE_DIRS := ./resource

SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' )

#SYSTOLIC_SRC := $(shell find $(RESOURCE_DIRS) -name 'systolic.txt' ) 
#DNN_SRCS := $(shell find $(RESOURCE_DIRS) -name '*summary.txt' )

OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

#INC_DIRS := $(shell find $(SRC_DIRS) -type d)
#CPPFLAGS := $(INC_FLAGS) -MMD -MP
CPPFLAGS := -std=c++14


#run: $(TARGET_EXEC)
#	echo "./ACA $(SYSTOLIC_SRC) $(DNN_SRCS)" > $(RUNSHELL_NAME).sh	

$(TARGET_EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $@ $(LDFLAGS)

$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@



.PHONY: clean
clean:
	rm -r $(BUILD_DIR)
	rm $(TARGET_EXEC)



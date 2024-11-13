
/*
* EcoMender Bot (EB): Task 2B Path Planner
*
* This program computes the valid path from the start point to the end point.
* Make sure you don't change anything outside the "Add your code here" section.
*/

#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <limits.h>
#define V 32

#ifdef __linux__ // for host pc

    #include <stdio.h>

    void _put_byte(char c) { putchar(c); }

    void _put_str(char *str) {
        while (*str) {
            _put_byte(*str++);
        }
    }

    void print_output(uint8_t num) {
        if (num == 0) {
            putchar('0'); // if the number is 0, directly print '0'
            _put_byte('\n');
            return;
        }

        if (num < 0) {
            putchar('-'); // print the negative sign for negative numbers
            num = -num;   // make the number positive for easier processing
        }

        // convert the integer to a string
        char buffer[20]; // assuming a 32-bit integer, the maximum number of digits is 10 (plus sign and null terminator)
        uint8_t index = 0;

        while (num > 0) {
            buffer[index++] = '0' + num % 10; // convert the last digit to its character representation
            num /= 10;                        // move to the next digit
        }
        // print the characters in reverse order (from right to left)
        while (index > 0) { putchar(buffer[--index]); }
        _put_byte('\n');
    }

    void _put_value(uint32_t val) { print_output(val); }

#else  // for the test device

    void _put_value(uint32_t val) { }
    void _put_str(char *str) { }

#endif

uint8_t get_neighborcount(uint32_t node_data) {
    return (node_data >> (30)) + 1;  // Extract first 2 bits
}

uint8_t get_neighbor(uint32_t node_data, int index) {
    return (node_data >> (25 - 5 * index)) & 0x1F;  // Extract 5 bits for each neighbor
}

void set_distance(uint32_t *node_data, uint8_t distance) {
    *node_data = (*node_data & 0xFFFFFC1F) | ((distance) << 5); // Mask and set distance
}

// Get distance
uint8_t get_distance(uint32_t node_data) {
    return (node_data>>5) & 0x1F ;
}

void set_previous(uint32_t *node_data, uint8_t previous) {
    *node_data = (*node_data & 0xFFFFFFE0) | (previous) ;
}

uint8_t get_previous(uint32_t node_data) {
    return (node_data) & 0x1F;
}

void dijkstra(uint32_t *graph, const uint8_t start, const uint8_t end, uint8_t *path, uint8_t *path_len, bool *visited) {
    set_distance(&graph[start], 0x00);
    set_previous(&graph[start], start);  // No previous node for the start
    
    
    for (int i = 0; i < V; ++i) visited[i] = 0;
    int min_distance ;
    int u ;

    for (int i = 0; i < V; ++i) {
         min_distance = 32;
         u = 32 ; 

        for (int j = 0; j < V; ++j) {
            if (visited[j] == 0 && (get_distance(graph[j]) < min_distance)) {
                min_distance = get_distance(graph[j]);
                u = j;
            }
        }
        if (u == end) break;
        visited[u] = 1;
        

        for (int k = 0; k < (get_neighborcount(graph[u])); ++k) {
            int neighbor = get_neighbor(graph[u], k);
            
            if ( ((get_distance(graph[u]) + 1 )< get_distance(graph[neighbor])) && visited[neighbor]==0) {
                set_distance(&graph[neighbor], get_distance(graph[u]) + 1);
                set_previous(&graph[neighbor], u);
            }
        }
    }
        *path_len = 0;
        for (int current = end; current < 32; current = get_previous(graph[current])) {
            path[(*path_len)++] = current;
            if (current == get_previous(graph[current]))  break;
        }
        
        for (int i = 0; i < *path_len / 2; ++i) {
            uint8_t temp = path[i];
            path[i] = path[*path_len - 1 - i];
            path[*path_len - 1 - i] = temp;
        }
        
}
 
// main function
int main(int argc, char const *argv[]) {

    #ifdef __linux__

        const uint8_t START_POINT   = atoi(argv[1]);
        const uint8_t END_POINT     = atoi(argv[2]);
        uint8_t NODE_POINT          = 0;
        uint8_t CPU_DONE            = 0;

    #else
        // Address value of variables for RISC-V Implementation
        #define START_POINT         (* (volatile uint8_t * ) 0x02000000)
        #define END_POINT           (* (volatile uint8_t * ) 0x02000004)
        #define NODE_POINT          (* (volatile uint8_t * ) 0x02000008)
        #define CPU_DONE            (* (volatile uint8_t * ) 0x0200000c)

    #endif

    uint8_t idx = 0;

    /* Functions Usage

    instead of using printf() function for debugging,
    use the below function calls to print a number, string or a newline
    

    for newline: _put_byte('\n');
    for string:  _put_str("your string here");
    for number:  _put_value(your_number_here);

    Examples:
            _put_value(START_POINT);
            _put_value(END_POINT);
            _put_str("Hello World!");
            _put_byte('\n');
    */
    #ifdef __linux__
        uint32_t graph[32] = {0} ;
    #else
        uint32_t *graph = (uint32_t *) 0x02000010;
    #endif

    #ifdef __linux__
        bool visited[32] = {0} ;
    #else
        bool *visited = (bool *) 0x020000A0;
    #endif

    #ifdef __linux__
        uint8_t path_planned[32] ;
    #else
        uint8_t *path_planned = (uint8_t *) 0x020000AB;
    #endif

    graph[0] = 0x8c1503ff;
    graph[1] = 0x962003ff;
    graph[2] = 0xc23217ff;
    graph[3] = 0x40003ff;
    graph[4] = 0x40003ff;
    graph[5] = 0x40003ff;
    graph[6] = 0xce8483ff;
    graph[7] = 0xc0003ff;
    graph[8] = 0xc0003ff;
    graph[9] = 0xc0003ff;
    graph[10] = 0xc0bd63ff;
    graph[11] = 0xd419b3ff;
    graph[12] = 0x9ab703ff;
    graph[13] = 0x180003ff;
    graph[14] = 0x98f803ff;
    graph[15] = 0x1c0003ff;
    graph[16] = 0x9d1903ff;
    graph[17] = 0x200003ff;
    graph[18] = 0xa13a83ff;
    graph[19] = 0xa54583ff;
    graph[20] = 0x260003ff;
    graph[21] = 0xa56b83ff;
    graph[22] = 0x2a0003ff;
    graph[23] = 0xabec03ff;
    graph[24] = 0xaf9503ff;
    graph[25] = 0x300003ff;
    graph[26] = 0xb6ae03ff;
    graph[27] = 0x340003ff;
    graph[28] = 0xbbaf03ff;
    graph[29] = 0x380003ff;
    graph[30] = 0xb9fb83ff;
    graph[31] = 0x3c0003ff;
    
    dijkstra(graph, START_POINT, END_POINT, path_planned, &idx,visited);

    for (int i = 0; i < idx; ++i) {
        NODE_POINT = path_planned[i];
    }
    CPU_DONE = 1;

    #ifdef __linux__    // for host pc

        _put_str("######### Planned Path #########\n");
        for (int i = 0; i < idx; ++i) {
            _put_value(path_planned[i]);
        }
        _put_str("################################\n");

    #endif

    return 0;
}


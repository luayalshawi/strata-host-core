/*
 * author: iancain
 */

// Memory pool of fixed sized blocks
// Objective: speed operations of malloc/free and adapt idiomatically and separate memory
//           management from other data storage patterns such as linked lists, stacks,
//           double buffer
// Limitations: Fixed sized memory blocks. Due to the O(1) requirement only fixed sized
//                memory allocation can be performed. Memory fragmentation and
//                collection/collating operations are not desired due to performance demands
//
// Support O(1) operation in acquire and release operations
// Strategy:
// stack object to manage memory blocks
// acquire = pop_front  (acquire block off the first/bottom of stack)
// release = push_back  (release block by putting on back/bottom of stack)
//
#include "memory_pool.h"

typedef struct memory_pool {
    size_t number_of_blocks; // number of blocks
    size_t block_size;   // size of each block
    size_t available;

    memory_pool_node_t * pool;
    memory_pool_node_t * top;

} memory_pool_t;

// static to keep private to this C file. g_* to indicate it is a global
static memory_pool_t g_pool;

bool memory_pool_init()
{
    size_t number_of_blocks = 5, block_size = 130;

    memory_pool_node_t *last;
    // Mus - compound literals
    g_pool = (memory_pool_t){0};   // zero/null all elements of pool structure
    int n =0;

    printf("MEMORY POOL INIT:(number_of_blocks=%zu, block_size=%zu)\n", number_of_blocks, block_size);

    for( n = 0; n < number_of_blocks; ++n ) {

        memory_pool_node_t * node = (memory_pool_node_t *) malloc (sizeof(memory_pool_node_t));
        if( node == NULL){
            printf("OOM ERROR.\n");
            return false;
        }

        node->data = malloc ((block_size));
        printf("node->data: %p\n", node->data);

        if( node->data == NULL) {
            printf("OOM ERROR.\n");
            return false;
        }

        node->magic = NODE_MAGIC;  // set the magic for data integrity checks
        node->size = block_size;
        node->inuse = false;
        node->prev = NULL;   // may not need to be double linked
        node->next = NULL;

        if( g_pool.pool == NULL ) {
            g_pool.pool = node;  // pool is empty set first node
            g_pool.top = node;
            last = node;

            printf("MEMORY POOL INIT: i=%d, node=%p block_size=%zu, data=%p, prev=%p, next=%p, magic = 0x%x\n",
                   n, node, node->size, node->data, node->prev, node->next, node->magic);
            continue;
        }
        // add new node to stack
        last->next = node;
        node->prev = last;
        last = node;

        // DEBUG : TODO remove
        printf("MEMORY POOL INIT: i=%d, node=%p block_size=%zu, data=%p, prev=%p, next=%p, magic = 0x%x\n",
               n, node, node->size, node->data, node->prev, node->next, node->magic);
    }

    printf ("MEMORY POOL INIT: g_pool.top = %p\n", g_pool.top );
    g_pool.number_of_blocks = number_of_blocks;
    g_pool.block_size = block_size;
    g_pool.available = number_of_blocks;

    return n == number_of_blocks ? true : false;
}

void memory_pool_dump()
{
    printf("memory_pool_dump(number_of_blocks=%zu, available=%zu, block_size=%zu, magic = 0x%x)\n",
           g_pool.number_of_blocks, g_pool.available, g_pool.block_size, g_pool.pool->magic);

    memory_pool_node_t * node = g_pool.pool;
    for(int n = 0; node != NULL; ++n ) {
        printf("memory_pool_dump POOL: i=%d, inuse=%s, node=%p block_size=%zu, data=%p, prev=%p, next=%p\n",
               n, node->inuse ? "true":"false", node, node->size, node->data, node->prev, node->next);
        node = node->next;
    }
}
bool memory_pool_acquire(memory_pool_handle_t *handle)
{
    if( g_pool.top == NULL ) {
        printf("memory_pool_acquire: ERROR: no available memory blocks\n");
        return false;
    }
    // unsigned int 64
    *handle = (memory_pool_handle_t) g_pool.top;   // give them bottom of stack
    printf("MEMORY POOL ACQUIRE: address of g_pool.top is: = %p\n", g_pool.top);
    g_pool.top->inuse = true;
    g_pool.top = g_pool.top->next;               // pop stack item
    g_pool.available --;

//    printf("MEMORY POOL ACQUIRE: value of magic node is: %x\n", g_pool.top->magic);
    printf("MEMORY POOL ACQUIRE: handle = 0x%llx\n", *handle);
    return true;
}

bool memory_pool_release(memory_pool_handle_t handle)
{
    if( handle == 0 ) {
        printf("memory_pool_release: ERROR: bad handle. NULL\n");
        return false;
    }

    memory_pool_node_t * node = (memory_pool_node_t *)handle;
    printf("MEMORY_POOL_RELEASE: content of node->magic is %x\n", node->magic);
    if( node->magic != NODE_MAGIC ) {
        printf("memory_pool_release: ERROR: bad handle magic. You lost the magic\n");
        return false;
    }

    printf("memory_pool_release: handle = 0x%llx\n", handle);

    // push on stack
    node->prev = NULL;
    node->next = g_pool.top;
    node->inuse = false;
    g_pool.top = node;
    g_pool.available ++;

    return true;
}

void memory_pool_destroy()
{
    memory_pool_node_t * node = g_pool.pool;
    for(int n = 0; node != NULL; ++n ) {
        printf("memory_pool_destroy: i=%d, node=0x%p block_size=%zu, data=0x%p, prev=0x%p, next=0x%p\n",
               n, node, node->size, node->data, node->prev, node->next);

        memory_pool_node_t * tmp = node; // save off node to free memory
        node = node->next;

        tmp->magic = 0;  // lose the magic
        free(tmp->data);
        free(tmp);
    }

    g_pool = (memory_pool_t){0};
}


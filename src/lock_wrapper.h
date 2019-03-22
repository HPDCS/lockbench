#ifndef __LOCK_WRAPPER__
#define __LOCK_WRAPPER__


#ifdef TAS_LOCK
#include <tas_spinlock.h>
typedef tas_spinlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			tas_spinlock_unlock(&lock);}
static inline void acquire_lock() {			tas_spinlock_lock(&lock);}
char* lock_to_string() { return " TAS_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			tas_spinlock_init(&lock);
}
#endif


#ifdef CAS_LOCK
#include <cas_spinlock.h>
typedef cas_spinlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			cas_spinlock_unlock(&lock);}
static inline void acquire_lock() {			cas_spinlock_lock(&lock);}
char* lock_to_string() { return " CAS_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			cas_spinlock_init(&lock);
}
#endif


#ifdef MUTEX_LOCK
#include <mutex.h>
typedef mutex_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			mutex_unlock(&lock);}
static inline void acquire_lock() {			mutex_lock(&lock);}
char* lock_to_string() { return " MUTEX_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			mutex_init(&lock);
}
#endif


#ifdef PTHREAD_MUTEX_LOCK 
#include <pthread.h>
typedef pthread_mutex_t lock_t;
lock_t lock = PTHREAD_MUTEX_INITIALIZER;
static inline void destroy_lock() 			{}
static inline void release_lock() {			pthread_mutex_unlock(&lock);}
static inline void acquire_lock() {			pthread_mutex_lock(&lock);}
char* lock_to_string() { return " PTHREAD_MUTEX_LOCK"; }
static inline void init_lock(unsigned long long spin_window){}
#endif


#ifdef PTHREAD_ADAPTIVE_MUTEX_LOCK
#define _GNU_SOURCE
#include <pthread.h>
typedef pthread_mutex_t lock_t;
lock_t lock = PTHREAD_ADAPTIVE_MUTEX_INITIALIZER_NP;
static inline void destroy_lock() 			{}
static inline void release_lock() {			pthread_mutex_unlock(&lock);}
static inline void acquire_lock() {			pthread_mutex_lock(&lock);}
char* lock_to_string() { return " PTHREAD_ADAPTIVE_MUTEX_LOCK"; }
static inline void init_lock(unsigned long long spin_window){}
#endif


#ifdef PTHREAD_SPINLOCK_LOCK
#include <pthread.h>
typedef pthread_spinlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			pthread_spin_unlock(&lock);}
static inline void acquire_lock() {			pthread_spin_lock(&lock);}
char* lock_to_string() { return " PTHREAD_SPINLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			pthread_spin_init(&lock, 0);
}
#endif


#ifdef QUEUED_SPINLOCK_LOCK
#include <queued_spinlock.h>
typedef queued_spinlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			queued_spinlock_unlock(&lock);}
static inline void acquire_lock() {			queued_spinlock_lock(&lock);}
char* lock_to_string() { return " QUEUED_SPINLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			queued_spinlock_init(&lock);
}
#endif


#ifdef MUTLOCK_LOCK
#include <static_mutlock.h>
typedef static_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			static_mutlock_unlock(&lock);}
static inline void acquire_lock() {			static_mutlock_lock(&lock);}
char* lock_to_string() { return " MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			static_mutlock_init(&lock, spin_window);
}
#endif


#ifdef NOFIFO_MUTLOCK_LOCK
#include <static_nofifo_mutlock.h>
typedef static_nofifo_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			static_nofifo_mutlock_unlock(&lock);}
static inline void acquire_lock() {			static_nofifo_mutlock_lock(&lock);}
char* lock_to_string() { return " NOFIFO_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			static_nofifo_mutlock_init(&lock, spin_window);
}
#endif


#ifdef NOFIFO_SKIPWAIT_MUTLOCK_LOCK
#include <static_nofifo_skipwait_mutlock.h>
typedef static_nofifo_skipwait_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			static_nofifo_skipwait_mutlock_unlock(&lock);}
static inline void acquire_lock() {			static_nofifo_skipwait_mutlock_lock(&lock);}
char* lock_to_string() { return " NOFIFO_SKIPWAIT_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			static_nofifo_skipwait_mutlock_init(&lock, spin_window);
}
#endif


#ifdef ONEVENT_H_MUTLOCK_LOCK
#include <onevent_h_mutlock.h>
typedef onevent_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			onevent_mutlock_destroy(&lock);					}
static inline void release_lock() {			onevent_mutlock_unlock(&lock);}
static inline void acquire_lock() {			onevent_mutlock_lock(&lock);}
char* lock_to_string() { return " ONEVENT_H_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			onevent_mutlock_param_t onevent_params;;
			onevent_params.initial_sws = spin_window;
			onevent_mutlock_init(&lock, &onevent_params); // attiva euristica
}
#endif


#ifdef ONEVENT_H_NOFIFO_MUTLOCK_LOCK
#include <onevent_h_nofifo_mutlock.h>
typedef onevent_nofifo_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			onevent_nofifo_mutlock_destroy(&lock);			}
static inline void release_lock() {			onevent_nofifo_mutlock_unlock(&lock);}
static inline void acquire_lock() {			onevent_nofifo_mutlock_lock(&lock);}
char* lock_to_string() { return " ONEVENT_H_NOFIFO_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			onevent_nofifo_mutlock_param_t onevent_nofifo_params;
			onevent_nofifo_params.initial_sws = spin_window;
			onevent_nofifo_mutlock_init(&lock, &onevent_nofifo_params); // attiva euristica
}

#endif


#ifdef ONEVENT_H_NOFIFO_SKIPWAIT_MUTLOCK_LOCK
#include <onevent_h_nofifo_skipwait_mutlock.h>
typedef onevent_nofifo_skipwait_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			onevent_nofifo_skipwait_mutlock_destroy(&lock);	}
static inline void release_lock() {			onevent_nofifo_skipwait_mutlock_unlock(&lock);}
static inline void acquire_lock() {			onevent_nofifo_skipwait_mutlock_lock(&lock);}
char* lock_to_string() { return " ONEVENT_H_NOFIFO_SKIPWAIT_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			onevent_nofifo_skipwait_mutlock_param_t onevent_nofifo_skipwait_params;
			onevent_nofifo_skipwait_params.initial_sws = spin_window;
			onevent_nofifo_skipwait_mutlock_init(&lock, &onevent_nofifo_skipwait_params); // attiva euristica
}
#endif


#ifdef PROB_SAMPLED_H_MUTLOCK_LOCK
#include <prob_h_mutlock.h>
typedef prob_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			prob_mutlock_destroy(&lock);				}	
static inline void release_lock() {			prob_mutlock_unlock(&lock);}
static inline void acquire_lock() {			prob_mutlock_lock(&lock);}
char* lock_to_string() { return " PROB_SAMPLED_H_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			prob_mutlock_param_t prob_params;
			prob_params.initial_sws = spin_window;
			prob_mutlock_init(&lock, &prob_params); // attiva euristica
}
#endif


#ifdef QUEUED_MUTLOCK_LOCK
#include <queued_mutlock.h>
typedef queued_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() 			{}
static inline void release_lock() {			queued_mutlock_unlock(&lock);}
static inline void acquire_lock() {			queued_mutlock_lock(&lock);}
char* lock_to_string() { return " QUEUED_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			queued_mutlock_init(&lock, spin_window);
}
#endif


#ifdef HEURISTIC_MUTLOCK_LOCK
#include <heuristic_mutlock.h>
typedef heuristic_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			heuristic_mutlock_destroy(&lock);			}
static inline void release_lock() {			heuristic_mutlock_unlock(&lock);}
static inline void acquire_lock() {			heuristic_mutlock_lock(&lock);}
char* lock_to_string() { return " HEURISTIC_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			heuristic_mutlock_param_t heuristic_params;
			heuristic_params.initial_sws = spin_window;
			heuristic_mutlock_init(&lock, &heuristic_params);
}
#endif


#ifdef SEM_HEURISTIC_MUTLOCK_LOCK
#include <sem_heuristic_mutlock.h>
typedef sem_heuristic_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_heuristic_mutlock_destroy(&lock);		}
static inline void release_lock() {			sem_heuristic_mutlock_unlock(&lock);}
static inline void acquire_lock() {			sem_heuristic_mutlock_lock(&lock);}
char* lock_to_string() { return " SEM_HEURISTIC_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_heuristic_mutlock_param_t sem_heuristic_params;
			sem_heuristic_params.initial_sws = spin_window;
			sem_heuristic_mutlock_init(&lock, &sem_heuristic_params);
}
#endif


#ifdef SEM_ONEVENT_H_NOFIFO_MUTLOCK_LOCK
#include <sem_onevent_h_nofifo_mutlock.h>
typedef sem_onevent_nofifo_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_onevent_nofifo_mutlock_destroy(&lock);	}
static inline void release_lock() {			sem_onevent_nofifo_mutlock_unlock(&lock);}
static inline void acquire_lock() {			sem_onevent_nofifo_mutlock_lock(&lock);}
char* lock_to_string() { return " SEM_ONEVENT_H_NOFIFO_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_onevent_nofifo_mutlock_param_t sem_onevent_nofifo_params;
			sem_onevent_nofifo_params.initial_sws = spin_window;
			sem_onevent_nofifo_mutlock_init(&lock, &sem_onevent_nofifo_params); // attiva euristica
}
#endif


#ifdef NSS_MUTLOCK_LOCK
#include <nss_mutlock.h>
typedef nss_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			nss_mutlock_destroy(&lock);			}
static inline void release_lock() {			nss_mutlock_unlock(&lock);}
static inline void acquire_lock() {			nss_mutlock_lock(&lock);}
char* lock_to_string() { return " NSS_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			nss_mutlock_param_t nss_params;
			nss_params.initial_sws = spin_window;
			nss_mutlock_init(&lock, &nss_params); // attiva euristica
}
#endif


#ifdef THC1_MUTLOCK_LOCK
#include <thc1_mutlock.h>
typedef thc1_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			thc1_mutlock_destroy(&lock);		}
static inline void release_lock() {			thc1_mutlock_unlock(&lock);}
static inline void acquire_lock() {			thc1_mutlock_lock(&lock);}
char* lock_to_string() { return " THC1_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			thc1_mutlock_param_t thc1_params;
			thc1_params.initial_sws = spin_window;
			thc1_mutlock_init(&lock, &thc1_params); // attiva euristica
}
#endif


#ifdef SEM_NSS_MUTLOCK_LOCK
#include <sem_nss_mutlock.h>
typedef sem_nss_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_nss_mutlock_destroy(&lock);		}
static inline void release_lock() {			sem_nss_mutlock_unlock(&lock);}
static inline void acquire_lock() {			sem_nss_mutlock_lock(&lock);}
char* lock_to_string() { return " SEM_NSS_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_nss_mutlock_param_t sem_nss_params;
			sem_nss_params.initial_sws = spin_window;
			sem_nss_mutlock_init(&lock, &sem_nss_params); // attiva euristica
}
#endif


#ifdef SEM_THC1_MUTLOCK_LOCK
#include <sem_thc1_mutlock.h>
typedef sem_thc1_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_thc1_mutlock_destroy(&lock);	}
static inline void release_lock() {			sem_thc1_mutlock_unlock(&lock);}
static inline void acquire_lock() {			sem_thc1_mutlock_lock(&lock);}
char* lock_to_string() { return " SEM_THC1_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_thc1_mutlock_param_t sem_thc1_params;
			sem_thc1_params.initial_sws = spin_window;
			sem_thc1_mutlock_init(&lock, &sem_thc1_params); // attiva euristica
}
#endif


#ifdef NSS2_MUTLOCK_LOCK
#include <nss2_mutlock.h>
typedef nss2_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			nss2_mutlock_destroy(&lock);		}
static inline void release_lock() {			nss2_mutlock_unlock(&lock);}
static inline void acquire_lock() {			nss2_mutlock_lock(&lock);}
char* lock_to_string() { return " NSS2_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			nss2_mutlock_param_t nss2_params;
			nss2_params.initial_sws = spin_window;
			nss2_mutlock_init(&lock, &nss2_params); // attiva euristica
}
#endif


#ifdef THC12_MUTLOCK_LOCK
#include <thc12_mutlock.h>
typedef thc12_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			thc12_mutlock_destroy(&lock);		}
static inline void release_lock() {			thc12_mutlock_unlock(&lock);}
static inline void acquire_lock() {			thc12_mutlock_lock(&lock);}
char* lock_to_string() { return " THC12_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			thc12_mutlock_param_t thc12_params;
			thc12_params.initial_sws = spin_window;
			thc12_mutlock_init(&lock, &thc12_params); // attiva euristica
}
#endif


#ifdef SEM_NSS2_MUTLOCK_LOCK
#include <sem_nss2_mutlock.h>
typedef sem_nss2_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_nss2_mutlock_destroy(&lock);	}
static inline void release_lock() {			sem_nss2_mutlock_unlock(&lock);}
static inline void acquire_lock() {			sem_nss2_mutlock_lock(&lock);}
char* lock_to_string() { return " SEM_NSS2_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_nss2_mutlock_param_t sem_nss2_params;
			sem_nss2_params.initial_sws = spin_window;
			sem_nss2_mutlock_init(&lock, &sem_nss2_params); // attiva euristica
}
#endif


#ifdef SEM_THC12_MUTLOCK_LOCK
#include <sem_thc12_mutlock.h>
typedef sem_thc12_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_thc12_mutlock_destroy(&lock);	}
static inline void release_lock() {			sem_thc12_mutlock_unlock(&lock);}
static inline void acquire_lock() {			sem_thc12_mutlock_lock(&lock);}
char* lock_to_string() { return " SEM_THC12_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_thc12_mutlock_param_t sem_thc12_params;
			sem_thc12_params.initial_sws = spin_window;
			sem_thc12_mutlock_init(&lock, &sem_thc12_params); // attiva euristica
}
#endif


#ifdef FREQ_MUTLOCK_LOCK
#include <freq_mutlock.h>
typedef freq_mutlock_wrapper_t lock_t;
lock_t lock;
static inline void destroy_lock() {			freq_mutlock_wrap_destroy(&lock);		}
static inline void release_lock() {			freq_mutlock_wrap_unlock(&lock);			}
static inline void acquire_lock() {			freq_mutlock_wrap_lock(&lock);			}
char* lock_to_string() { return " FREQ_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			freq_mutlock_param_t freq_params;
			freq_params.initial_sws = spin_window;
			freq_mutlock_wrap_init(&lock, &freq_params); // attiva euristica
}
#endif


#ifdef SEM_FREQ_MUTLOCK_LOCK
#include <sem_freq_mutlock.h>
typedef sem_freq_mutlock_wrapper_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_freq_mutlock_wrap_destroy(&lock);		}
static inline void release_lock() {			sem_freq_mutlock_wrap_unlock(&lock);			}
static inline void acquire_lock() {			sem_freq_mutlock_wrap_lock(&lock);			}
char* lock_to_string() { return " SEM_FREQ_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_freq_mutlock_param_t sem_freq_params;
			sem_freq_params.initial_sws = spin_window;
			sem_freq_mutlock_wrap_init(&lock, &sem_freq_params); // attiva euristica
}
#endif


#ifdef TCP_MUTLOCK_LOCK
#include <tcp_mutlock.h>
typedef tcp_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			tcp_mutlock_destroy(&lock);		}
static inline void release_lock() {			tcp_mutlock_unlock(&lock);			}
static inline void acquire_lock() {			tcp_mutlock_lock(&lock);			}
char* lock_to_string() { return " TCP_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			tcp_mutlock_param_t tcp_params;
			tcp_params.initial_sws = spin_window;
			tcp_mutlock_init(&lock, &tcp_params); // attiva euristica
}
#endif


#ifdef SEM_TCP_MUTLOCK_LOCK
#include <sem_tcp_mutlock.h>
typedef sem_tcp_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_tcp_mutlock_destroy(&lock);		}
static inline void release_lock() {			sem_tcp_mutlock_unlock(&lock);			}
static inline void acquire_lock() {			sem_tcp_mutlock_lock(&lock);			}
char* lock_to_string() { return " SEM_TCP_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_tcp_mutlock_param_t sem_tcp_params;
			sem_tcp_params.initial_sws = spin_window;
			sem_tcp_mutlock_init(&lock, &sem_tcp_params); // attiva euristica
}
#endif


#ifdef SEM_TCP2_MUTLOCK_LOCK
#include <sem_tcp2_mutlock.h>
typedef sem_tcp2_mutlock_t lock_t;
lock_t lock;
static inline void destroy_lock() {			sem_tcp2_mutlock_destroy(&lock);		}
static inline void release_lock() {			sem_tcp2_mutlock_unlock(&lock);			}
static inline void acquire_lock() {			sem_tcp2_mutlock_lock(&lock);			}
char* lock_to_string() { return " SEM_TCP2_MUTLOCK_LOCK"; }
static inline void init_lock(unsigned long long spin_window){
			sem_tcp2_mutlock_param_t sem_tcp2_params;
			sem_tcp2_params.initial_sws = spin_window;
			sem_tcp2_mutlock_init(&lock, &sem_tcp2_params); // attiva euristica
}
#endif


#endif

# UAICP Discovery Mesh Reference Implementation

## Overview

This directory contains the reference implementation of the Universal Discovery Mesh component of UAICP. The Discovery Mesh enables AI systems to discover capabilities across protocol boundaries using multiple discovery mechanisms.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Discovery Mesh Core                      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ DNS-based   │  │ Centralized │  │ Decentralized (DHT) │  │
│  │ Discovery   │  │ Registry    │  │ Discovery           │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Service     │  │ Capability  │  │ Health Monitoring   │  │
│  │ Registry    │  │ Matching    │  │ & Load Balancing    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Implementation Components

### Core Discovery Interface

```typescript
/**
 * Core interface for the Universal Discovery Mesh
 */
export interface DiscoveryMesh {
  /**
   * Find services matching specified capabilities
   */
  findServices(
    capabilities: Capability[], 
    options?: DiscoveryOptions
  ): Promise<ServiceDescription[]>;
  
  /**
   * Register a service with the discovery mesh
   */
  registerService(service: ServiceDescription): Promise<RegistrationResult>;
  
  /**
   * Update service registration
   */
  updateService(
    serviceId: string, 
    updates: Partial<ServiceDescription>
  ): Promise<UpdateResult>;
  
  /**
   * Remove service from discovery mesh
   */
  deregisterService(serviceId: string): Promise<DeregistrationResult>;
  
  /**
   * Get health status of the discovery mesh
   */
  getHealthStatus(): Promise<HealthStatus>;
}
```

### Discovery Options

```typescript
export interface DiscoveryOptions {
  /** Preferred protocols in order of preference */
  protocolPreferences?: string[];
  
  /** Allow fallback to alternative services */
  fallbackAllowed?: boolean;
  
  /** Discovery mechanisms to use */
  discoveryMechanisms?: DiscoveryMechanism[];
  
  /** Maximum number of results to return */
  maxResults?: number;
  
  /** Geographic constraints for services */
  regionConstraints?: string[];
  
  /** Minimum reliability score (0-1) */
  minReliability?: number;
  
  /** Require verified services only */
  requireVerification?: boolean;
  
  /** Timeout for discovery operations */
  timeout?: number;
  
  /** Enable caching of discovery results */
  enableCaching?: boolean;
}

export type DiscoveryMechanism = 'dns' | 'centralized' | 'dht' | 'mdns' | 'well-known';
```

### Service Registration

```typescript
export interface RegistrationResult {
  success: boolean;
  serviceId: string;
  registrationId: string;
  expiresAt: Date;
  discoveryEndpoints: string[];
  error?: string;
}

export interface UpdateResult {
  success: boolean;
  serviceId: string;
  updatedFields: string[];
  version: number;
  error?: string;
}

export interface DeregistrationResult {
  success: boolean;
  serviceId: string;
  removedFrom: DiscoveryMechanism[];
  error?: string;
}
```

## Reference Implementation

### Basic Discovery Mesh Implementation

```typescript
import { EventEmitter } from 'events';
import { DNSDiscovery } from './dns-discovery';
import { CentralizedRegistry } from './centralized-registry';
import { DHTDiscovery } from './dht-discovery';
import { ServiceHealthMonitor } from './health-monitor';

export class UniversalDiscoveryMesh extends EventEmitter implements DiscoveryMesh {
  private dnsDiscovery: DNSDiscovery;
  private centralizedRegistry: CentralizedRegistry;
  private dhtDiscovery: DHTDiscovery;
  private healthMonitor: ServiceHealthMonitor;
  private serviceCache: Map<string, CachedService>;
  private registeredServices: Map<string, ServiceDescription>;

  constructor(config: DiscoveryMeshConfig) {
    super();
    
    this.dnsDiscovery = new DNSDiscovery(config.dns);
    this.centralizedRegistry = new CentralizedRegistry(config.registry);
    this.dhtDiscovery = new DHTDiscovery(config.dht);
    this.healthMonitor = new ServiceHealthMonitor(config.health);
    this.serviceCache = new Map();
    this.registeredServices = new Map();
    
    this.setupHealthMonitoring();
  }

  async findServices(
    capabilities: Capability[], 
    options: DiscoveryOptions = {}
  ): Promise<ServiceDescription[]> {
    
    const cacheKey = this.generateCacheKey(capabilities, options);
    
    // Check cache first if enabled
    if (options.enableCaching && this.serviceCache.has(cacheKey)) {
      const cached = this.serviceCache.get(cacheKey)!;
      if (!this.isCacheExpired(cached)) {
        return cached.services;
      }
    }

    const discoveryMechanisms = options.discoveryMechanisms || ['centralized', 'dns', 'dht'];
    const allServices: ServiceDescription[] = [];
    const errors: Error[] = [];

    // Execute discovery across all mechanisms
    for (const mechanism of discoveryMechanisms) {
      try {
        const services = await this.discoverVia(mechanism, capabilities, options);
        allServices.push(...services);
      } catch (error) {
        errors.push(error as Error);
        console.warn(`Discovery via ${mechanism} failed:`, error);
      }
    }

    // Deduplicate services by serviceId
    const uniqueServices = this.deduplicateServices(allServices);
    
    // Filter and rank services
    const filteredServices = await this.filterAndRankServices(
      uniqueServices, 
      capabilities, 
      options
    );

    // Apply result limits
    const limitedServices = filteredServices.slice(0, options.maxResults || 50);

    // Cache results if enabled
    if (options.enableCaching) {
      this.serviceCache.set(cacheKey, {
        services: limitedServices,
        timestamp: Date.now(),
        ttl: 300000 // 5 minutes
      });
    }

    // Emit discovery event
    this.emit('servicesDiscovered', {
      capabilities,
      options,
      services: limitedServices,
      mechanisms: discoveryMechanisms,
      errors
    });

    return limitedServices;
  }

  async registerService(service: ServiceDescription): Promise<RegistrationResult> {
    const registrationId = this.generateRegistrationId();
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours
    
    try {
      // Register with centralized registry
      await this.centralizedRegistry.register(service, registrationId);
      
      // Register with DNS if supported
      if (service.discoveryMethods?.direct) {
        await this.dnsDiscovery.register(service, registrationId);
      }
      
      // Register with DHT
      await this.dhtDiscovery.register(service, registrationId);
      
      // Store locally
      this.registeredServices.set(service.serviceId, service);
      
      // Start health monitoring
      this.healthMonitor.startMonitoring(service.serviceId, service.endpoint);
      
      const result: RegistrationResult = {
        success: true,
        serviceId: service.serviceId,
        registrationId,
        expiresAt,
        discoveryEndpoints: [
          this.centralizedRegistry.getEndpoint(),
          this.dnsDiscovery.getEndpoint(),
          this.dhtDiscovery.getEndpoint()
        ]
      };
      
      this.emit('serviceRegistered', { service, result });
      
      return result;
      
    } catch (error) {
      const result: RegistrationResult = {
        success: false,
        serviceId: service.serviceId,
        registrationId,
        expiresAt,
        discoveryEndpoints: [],
        error: (error as Error).message
      };
      
      this.emit('registrationFailed', { service, error });
      
      return result;
    }
  }

  async updateService(
    serviceId: string, 
    updates: Partial<ServiceDescription>
  ): Promise<UpdateResult> {
    
    const existingService = this.registeredServices.get(serviceId);
    if (!existingService) {
      return {
        success: false,
        serviceId,
        updatedFields: [],
        version: 0,
        error: 'Service not found'
      };
    }

    try {
      const updatedService = { ...existingService, ...updates };
      const version = Date.now();
      
      // Update in all registries
      await Promise.all([
        this.centralizedRegistry.update(serviceId, updates, version),
        this.dnsDiscovery.update(serviceId, updates, version),
        this.dhtDiscovery.update(serviceId, updates, version)
      ]);
      
      // Update local storage
      this.registeredServices.set(serviceId, updatedService);
      
      // Clear relevant cache entries
      this.clearCacheForService(serviceId);
      
      const result: UpdateResult = {
        success: true,
        serviceId,
        updatedFields: Object.keys(updates),
        version
      };
      
      this.emit('serviceUpdated', { serviceId, updates, result });
      
      return result;
      
    } catch (error) {
      return {
        success: false,
        serviceId,
        updatedFields: [],
        version: 0,
        error: (error as Error).message
      };
    }
  }

  async deregisterService(serviceId: string): Promise<DeregistrationResult> {
    const removedFrom: DiscoveryMechanism[] = [];
    
    try {
      // Remove from centralized registry
      await this.centralizedRegistry.deregister(serviceId);
      removedFrom.push('centralized');
      
      // Remove from DNS
      await this.dnsDiscovery.deregister(serviceId);
      removedFrom.push('dns');
      
      // Remove from DHT
      await this.dhtDiscovery.deregister(serviceId);
      removedFrom.push('dht');
      
      // Stop health monitoring
      this.healthMonitor.stopMonitoring(serviceId);
      
      // Remove from local storage
      this.registeredServices.delete(serviceId);
      
      // Clear cache
      this.clearCacheForService(serviceId);
      
      const result: DeregistrationResult = {
        success: true,
        serviceId,
        removedFrom
      };
      
      this.emit('serviceDeregistered', { serviceId, result });
      
      return result;
      
    } catch (error) {
      return {
        success: false,
        serviceId,
        removedFrom,
        error: (error as Error).message
      };
    }
  }

  async getHealthStatus(): Promise<HealthStatus> {
    return {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      components: {
        dnsDiscovery: await this.dnsDiscovery.getHealth(),
        centralizedRegistry: await this.centralizedRegistry.getHealth(),
        dhtDiscovery: await this.dhtDiscovery.getHealth(),
        healthMonitor: await this.healthMonitor.getHealth()
      },
      metrics: {
        registeredServices: this.registeredServices.size,
        cacheSize: this.serviceCache.size,
        activeMonitoredServices: this.healthMonitor.getActiveCount()
      }
    };
  }

  private async discoverVia(
    mechanism: DiscoveryMechanism,
    capabilities: Capability[],
    options: DiscoveryOptions
  ): Promise<ServiceDescription[]> {
    
    switch (mechanism) {
      case 'dns':
        return await this.dnsDiscovery.discover(capabilities, options);
      case 'centralized':
        return await this.centralizedRegistry.discover(capabilities, options);
      case 'dht':
        return await this.dhtDiscovery.discover(capabilities, options);
      case 'mdns':
        return await this.discoverViaMDNS(capabilities, options);
      case 'well-known':
        return await this.discoverViaWellKnown(capabilities, options);
      default:
        throw new Error(`Unsupported discovery mechanism: ${mechanism}`);
    }
  }

  private deduplicateServices(services: ServiceDescription[]): ServiceDescription[] {
    const seen = new Set<string>();
    return services.filter(service => {
      if (seen.has(service.serviceId)) {
        return false;
      }
      seen.add(service.serviceId);
      return true;
    });
  }

  private async filterAndRankServices(
    services: ServiceDescription[],
    capabilities: Capability[],
    options: DiscoveryOptions
  ): Promise<ServiceDescription[]> {
    
    // Filter by region constraints
    let filtered = services;
    if (options.regionConstraints?.length) {
      filtered = filtered.filter(service => 
        options.regionConstraints!.some(region => 
          service.capabilities.region?.includes(region)
        )
      );
    }

    // Filter by minimum reliability
    if (options.minReliability) {
      filtered = filtered.filter(service => {
        const reliability = this.healthMonitor.getReliability(service.serviceId);
        return reliability >= options.minReliability!;
      });
    }

    // Filter by verification requirement
    if (options.requireVerification) {
      filtered = filtered.filter(service => 
        service.security?.complianceCertifications?.length > 0
      );
    }

    // Rank services by capability match and other factors
    const ranked = await this.rankServices(filtered, capabilities, options);
    
    return ranked;
  }

  private async rankServices(
    services: ServiceDescription[],
    capabilities: Capability[],
    options: DiscoveryOptions
  ): Promise<ServiceDescription[]> {
    
    const scoredServices = await Promise.all(
      services.map(async service => {
        const score = await this.calculateServiceScore(service, capabilities, options);
        return { service, score };
      })
    );

    return scoredServices
      .sort((a, b) => b.score - a.score)
      .map(item => item.service);
  }

  private async calculateServiceScore(
    service: ServiceDescription,
    capabilities: Capability[],
    options: DiscoveryOptions
  ): Promise<number> {
    
    let score = 0;
    
    // Capability matching score (0-40 points)
    const capabilityScore = this.calculateCapabilityMatch(service, capabilities);
    score += capabilityScore * 40;
    
    // Protocol preference score (0-20 points)
    const protocolScore = this.calculateProtocolPreference(service, options);
    score += protocolScore * 20;
    
    // Performance score (0-20 points)
    const performanceScore = this.calculatePerformanceScore(service);
    score += performanceScore * 20;
    
    // Reliability score (0-15 points)
    const reliabilityScore = this.healthMonitor.getReliability(service.serviceId);
    score += reliabilityScore * 15;
    
    // Cost efficiency score (0-5 points)
    const costScore = this.calculateCostEfficiency(service);
    score += costScore * 5;
    
    return score;
  }

  private calculateCapabilityMatch(
    service: ServiceDescription,
    requiredCapabilities: Capability[]
  ): number {
    
    if (requiredCapabilities.length === 0) return 1;
    
    const matches = requiredCapabilities.filter(required => 
      service.capabilities.specificFeatures?.includes(required.name) ||
      service.capabilities.modalities?.includes(required.name)
    );
    
    return matches.length / requiredCapabilities.length;
  }

  private calculateProtocolPreference(
    service: ServiceDescription,
    options: DiscoveryOptions
  ): number {
    
    if (!options.protocolPreferences?.length) return 0.5;
    
    const index = options.protocolPreferences.indexOf(service.protocolType);
    if (index === -1) return 0;
    
    return 1 - (index / options.protocolPreferences.length);
  }

  private calculatePerformanceScore(service: ServiceDescription): number {
    const latency = service.capabilities.performance?.averageLatency || 5000;
    const throughput = service.capabilities.performance?.throughputLimit || 1;
    
    // Normalize latency (lower is better, 0-2000ms ideal)
    const latencyScore = Math.max(0, 1 - (latency - 2000) / 8000);
    
    // Normalize throughput (higher is better)
    const throughputScore = Math.min(1, throughput / 1000);
    
    return (latencyScore + throughputScore) / 2;
  }

  private calculateCostEfficiency(service: ServiceDescription): number {
    const costPerToken = service.pricing?.inputTokens || 0.01;
    
    // Normalize cost (lower is better, $0.001-$0.01 per token typical)
    return Math.max(0, 1 - (costPerToken - 0.001) / 0.009);
  }

  private generateCacheKey(capabilities: Capability[], options: DiscoveryOptions): string {
    const capabilityStr = capabilities.map(c => `${c.name}:${c.category}`).join(',');
    const optionsStr = JSON.stringify(options);
    return `${capabilityStr}|${optionsStr}`;
  }

  private isCacheExpired(cached: CachedService): boolean {
    return Date.now() - cached.timestamp > cached.ttl;
  }

  private clearCacheForService(serviceId: string): void {
    for (const [key, cached] of this.serviceCache.entries()) {
      if (cached.services.some(s => s.serviceId === serviceId)) {
        this.serviceCache.delete(key);
      }
    }
  }

  private generateRegistrationId(): string {
    return `reg_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  private setupHealthMonitoring(): void {
    this.healthMonitor.on('serviceDown', (serviceId: string) => {
      this.emit('serviceDown', serviceId);
      // Remove from active discovery results
      this.clearCacheForService(serviceId);
    });

    this.healthMonitor.on('serviceUp', (serviceId: string) => {
      this.emit('serviceUp', serviceId);
    });
  }

  private async discoverViaMDNS(
    capabilities: Capability[],
    options: DiscoveryOptions
  ): Promise<ServiceDescription[]> {
    // mDNS discovery implementation for local network services
    // This would use libraries like 'mdns' or 'bonjour'
    return [];
  }

  private async discoverViaWellKnown(
    capabilities: Capability[],
    options: DiscoveryOptions
  ): Promise<ServiceDescription[]> {
    // Well-known URI discovery implementation
    // This would check /.well-known/uaicp-service endpoints
    return [];
  }
}

interface CachedService {
  services: ServiceDescription[];
  timestamp: number;
  ttl: number;
}

interface DiscoveryMeshConfig {
  dns: DNSDiscoveryConfig;
  registry: CentralizedRegistryConfig;
  dht: DHTDiscoveryConfig;
  health: HealthMonitorConfig;
}
```

## Usage Examples

### Basic Service Discovery

```typescript
import { UniversalDiscoveryMesh } from '@uaicp/discovery-mesh';

const discoveryMesh = new UniversalDiscoveryMesh({
  dns: { servers: ['8.8.8.8', '1.1.1.1'] },
  registry: { endpoint: 'https://registry.uaicp.org' },
  dht: { bootstrap: ['bootstrap1.uaicp.org', 'bootstrap2.uaicp.org'] },
  health: { checkInterval: 30000 }
});

// Find text generation services
const textServices = await discoveryMesh.findServices([
  {
    name: 'text_generation',
    category: 'generation',
    required: true
  }
], {
  protocolPreferences: ['openai', 'mcp'],
  maxResults: 5,
  enableCaching: true
});

console.log(`Found ${textServices.length} text generation services`);
```

### Service Registration

```typescript
// Register a new service
const serviceDescription: ServiceDescription = {
  "@context": "https://uaicp.org/schema/v1.0",
  "serviceId": "my-ai-service",
  "provider": {
    "name": "My AI Company",
    "type": "cloud"
  },
  "protocolType": "openai",
  "capabilities": {
    "modalities": ["text"],
    "specificFeatures": ["function_calling", "json_mode"],
    "serviceType": "general"
  },
  "endpoint": "https://api.myai.com/v1"
};

const registrationResult = await discoveryMesh.registerService(serviceDescription);
console.log('Registration result:', registrationResult);
```

### Health Monitoring

```typescript
// Listen for service health events
discoveryMesh.on('serviceDown', (serviceId) => {
  console.log(`Service ${serviceId} is down`);
});

discoveryMesh.on('serviceUp', (serviceId) => {
  console.log(`Service ${serviceId} is back up`);
});

// Get overall health status
const healthStatus = await discoveryMesh.getHealthStatus();
console.log('Discovery mesh health:', healthStatus);
```

## Testing

```typescript
import { UniversalDiscoveryMesh } from '../src/discovery-mesh';

describe('Universal Discovery Mesh', () => {
  let discoveryMesh: UniversalDiscoveryMesh;

  beforeEach(() => {
    discoveryMesh = new UniversalDiscoveryMesh(testConfig);
  });

  test('should discover services by capability', async () => {
    const services = await discoveryMesh.findServices([
      { name: 'text_generation', category: 'generation', required: true }
    ]);

    expect(services.length).toBeGreaterThan(0);
    expect(services[0].capabilities.specificFeatures).toContain('text_generation');
  });

  test('should register and deregister services', async () => {
    const service = createTestService();
    
    const registrationResult = await discoveryMesh.registerService(service);
    expect(registrationResult.success).toBe(true);

    const deregistrationResult = await discoveryMesh.deregisterService(service.serviceId);
    expect(deregistrationResult.success).toBe(true);
  });
});
```

---

This reference implementation provides a solid foundation for the Universal Discovery Mesh component of UAICP, supporting multiple discovery mechanisms, health monitoring, and intelligent service ranking.

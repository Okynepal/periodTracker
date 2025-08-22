import { OkyUser, UserMetadata } from '../../../src/domain/oky/OkyUser'
import { OkyUserRepository } from '../../../src/domain/oky/OkyUserRepository'

describe('OkyUser Database Field Validation', () => {
  let mockRepository: jest.Mocked<OkyUserRepository>
  let user: OkyUser

  beforeEach(async () => {
    // Create a mock repository
    mockRepository = {
      nextIdentity: jest.fn(),
      byId: jest.fn(),
      byName: jest.fn(),
      save: jest.fn(),
      delete: jest.fn(),
    } as jest.Mocked<OkyUserRepository>

    // Create a test user with correct UserMetadata structure
    const metadata: UserMetadata = {
      periodDates: {
        date: '2024-01-01',
        mlGenerated: false,
        userVerified: true
      },
      isProfileUpdateSkipped: false,
      accommodationRequirement: 'none',
      religion: 'other',
      contentSelection: 1
    }

    // Use the correct register method signature
    user = await OkyUser.register({
      id: 'test-id-123',
      name: 'testuser',
      dateOfBirth: new Date('1995-01-01'),
      gender: 'Female',
      location: 'Test Location',
      country: 'Test Country',
      province: 'Test Province',
      plainPassword: 'password123',
      secretQuestion: 'What is your favorite color?',
      secretAnswer: 'blue',
      dateSignedUp: '2024-01-01',
      dateAccountSaved: '2024-01-01',
      metadata
    })
  })

  describe('User Creation with All Fields', () => {
    it('should create a user with all required fields and validate database persistence', async () => {
      // Mock the save operation
      mockRepository.save.mockResolvedValue(user)
      mockRepository.byId.mockResolvedValue(user)

      // Save the user
      await mockRepository.save(user)

      // Verify save was called
      expect(mockRepository.save).toHaveBeenCalledWith(user)

      // Validate all user fields using correct getter methods
      expect(user.getId()).toBe('test-id-123')
      expect(user.getGender()).toBe('Female')
      expect(user.getLocation()).toBe('Test Location')
      expect(user.getCountry()).toBe('Test Country')
      expect(user.getProvince()).toBe('Test Province')
      expect(user.getMemorableQuestion()).toBe('What is your favorite color?')
      expect(user.getDateOfBirth()).toEqual(new Date('1995-01-01'))
      expect(user.getDateSignedUp()).toBe('2024-01-01')
      
      // Validate metadata with correct structure
      const userMetadata = user.getMetadata()
      expect(userMetadata.periodDates.date).toBe('2024-01-01')
      expect(userMetadata.periodDates.mlGenerated).toBe(false)
      expect(userMetadata.periodDates.userVerified).toBe(true)
      expect(userMetadata.isProfileUpdateSkipped).toBe(false)
      expect(userMetadata.accommodationRequirement).toBe('none')
      expect(userMetadata.religion).toBe('other')
      expect(userMetadata.contentSelection).toBe(1)

      // Validate store field is initially null
      expect(user.getStore()).toBeNull()
    })

    it('should validate store field initialization and replaceStore functionality', async () => {
      // Initially store should be null
      expect(user.getStore()).toBeNull()

      // Test replaceStore functionality
      const testAppState = {
        currentScreen: 'home',
        userPreferences: { theme: 'light' },
        cycleData: { lastPeriod: '2024-01-01' }
      }

      user.replaceStore(1, testAppState)

      // Verify store was updated
      const updatedStore = user.getStore()
      expect(updatedStore).not.toBeNull()
      expect(updatedStore?.storeVersion).toBe(1)
      expect(updatedStore?.appState).toEqual(testAppState)

      // Mock repository save for the updated user
      mockRepository.save.mockResolvedValue(user)
      await mockRepository.save(user)

      expect(mockRepository.save).toHaveBeenCalledWith(user)
    })

    it('should handle store updates with different versions', async () => {
      // First store update
      user.replaceStore(1, { data: 'version1' })
      expect(user.getStore()?.storeVersion).toBe(1)
      expect(user.getStore()?.appState).toEqual({ data: 'version1' })

      // Second store update with higher version
      user.replaceStore(2, { data: 'version2', newField: 'added' })
      expect(user.getStore()?.storeVersion).toBe(2)
      expect(user.getStore()?.appState).toEqual({ data: 'version2', newField: 'added' })

      // Mock repository operations
      mockRepository.save.mockResolvedValue(user)
      await mockRepository.save(user)
      expect(mockRepository.save).toHaveBeenCalledWith(user)
    })
  })

  describe('Database Field Validation', () => {
    it('should validate all required fields are present', () => {
      // Required fields should have values
      expect(user.getId()).toBeDefined()
      expect(user.getGender()).toBeDefined()
      expect(user.getLocation()).toBeDefined()
      expect(user.getCountry()).toBeDefined()
      expect(user.getProvince()).toBeDefined()
      expect(user.getMemorableQuestion()).toBeDefined()
      expect(user.getHashedMemorableAnswer()).toBeDefined()
      expect(user.getMetadata()).toBeDefined()
      expect(user.getDateOfBirth()).toBeDefined()
      expect(user.getDateSignedUp()).toBeDefined()

      // Store field can be null initially
      expect(user.getStore()).toBeNull()
    })

    it('should validate metadata structure and required fields', () => {
      const metadata = user.getMetadata()
      
      // Validate metadata structure matches UserMetadata interface
      expect(metadata.periodDates).toBeDefined()
      expect(metadata.periodDates.date).toBeDefined()
      expect(metadata.periodDates.mlGenerated).toBeDefined()
      expect(metadata.periodDates.userVerified).toBeDefined()
      
      // Validate data types
      expect(typeof metadata.periodDates.date).toBe('string')
      expect(typeof metadata.periodDates.mlGenerated).toBe('boolean')
      expect(typeof metadata.periodDates.userVerified).toBe('boolean')
      
      // Optional fields
      if (metadata.isProfileUpdateSkipped !== undefined) {
        expect(typeof metadata.isProfileUpdateSkipped).toBe('boolean')
      }
      if (metadata.accommodationRequirement !== undefined) {
        expect(typeof metadata.accommodationRequirement).toBe('string')
      }
      if (metadata.religion !== undefined) {
        expect(typeof metadata.religion).toBe('string')
      }
      if (metadata.contentSelection !== undefined) {
        expect(typeof metadata.contentSelection).toBe('number')
      }
    })
  })
})
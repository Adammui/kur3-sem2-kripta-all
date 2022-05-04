class Aes
    # Pre-computed multiplicative inverse in GF(2^8)
    S_BOX = [0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
             0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
             0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
             0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
             0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
             0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
             0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
             0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
             0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
             0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
             0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
             0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
             0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
             0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
             0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
             0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16].freeze

    # Round Constant used for the Key Expansion [1st col is 2^(r-1) in GF(2^8)]
    R_CON = [[0x00, 0x00, 0x00, 0x00],
             [0x01, 0x00, 0x00, 0x00],
             [0x02, 0x00, 0x00, 0x00],
             [0x04, 0x00, 0x00, 0x00],
             [0x08, 0x00, 0x00, 0x00],
             [0x10, 0x00, 0x00, 0x00],
             [0x20, 0x00, 0x00, 0x00],
             [0x40, 0x00, 0x00, 0x00],
             [0x80, 0x00, 0x00, 0x00],
             [0x1b, 0x00, 0x00, 0x00],
             [0x36, 0x00, 0x00, 0x00] ].freeze

    # Block size (in words): no of columns in state (fixed for AES)
    CIPHER_BLOCK_SIZE = 4.freeze

    # AES Cipher function: encrypt 'input' state with Rijndael algorithm
    # applies Nr rounds (10/12/14) using key schedule w for 'add round key' stage
    # @param int[] input 16-byte (128-bit) input state array
    # @param int[][] w   Key schedule as 2D byte-array (Nr+1 x Nb bytes)
    # @returns int[]     Encrypted output state array
    def self.cipher(input, w)
      nr = w.length / CIPHER_BLOCK_SIZE - 1      # no of rounds: 10/12/14 for 128/192/256-bit keys
      state = [[],[],[],[]]                      # initialize 4x4 byte-array 'state' with input

      (0...(4 * CIPHER_BLOCK_SIZE)).each do |i|
        state[i % 4][(i / 4.0).floor] = input[i]
      end

      state = add_round_key(state, w, 0)
      (1...nr).each do |round|
        state = sub_bytes(state)
        state = shift_rows(state)
        state = mix_columns(state)
        state = add_round_key(state, w, round)
      end

      state = sub_bytes(state)
      state = shift_rows(state)
      state = add_round_key(state, w, nr)

      output = []
      (0...(4 * CIPHER_BLOCK_SIZE)).each { |i| output[i] = state[i % 4][(i / 4.0).floor] }
      output
    end

    #  Perform Key Expansion to generate a Key Schedule
    #
    #  @param int[] key Key as 16/24/32-byte array
    #  @returns int[][] Expanded key schedule as 2D byte-array (Nr+1 x Nb bytes)
    def self.key_expansion(key)
      nk = key.length / 4         # key length (in words): 4/6/8 for 128/192/256-bit keys
      nr = nk + 6                 # no of rounds: 10/12/14 for 128/192/256-bit keys

      w = []
      temp = []
      0.upto(nk - 1){ |i| w[i] = [key[4 * i], key[4 * i + 1], key[4 * i + 2], key[4 * i + 3]] }
      (nk...(CIPHER_BLOCK_SIZE * (nr + 1))).each do |i|
        w[i] = []
        0.upto(3){ |t| temp[t] = w[i - 1][t] }
        if i % nk == 0
          temp = sub_word(rotate_word(temp))
          0.upto(3){ |t| temp[t] ^= R_CON[i / nk][t]}
        elsif nk > 6 && i % nk == 4
          temp = sub_word(temp)
        end
        0.upto(3){ |t| w[i][t] = w[i - nk][t] ^ temp[t] }
      end
      w
    end

    # apply SBox to state
    def self.sub_bytes(state)
      0.upto(3) do |r|
        0.upto(CIPHER_BLOCK_SIZE - 1){ |c| state[r][c] = S_BOX[state[r][c]] }
      end
      state
    end

    # shift row r of state S left by r bytes
    def self.shift_rows(state)
      t = []
      1.upto(3) do |r|
        0.upto(3){ |c| t[c] = state[r][(c + r) % CIPHER_BLOCK_SIZE] }     # shift into temp copy
        0.upto(3){ |c| state[r][c] = t[c] }                               # and copy back
      end # note that this will work for nb = 4,5,6, but not 7,8 (always 4 for AES):
      state # see asmaes.sourceforge.net/rijndael/rijndaelImplementation.pdf
    end

    # combine bytes of each col of state S
    def self.mix_columns(state)
      0.upto(3) do |c|
        a=[]                  # 'a' is a copy of the current column from 'state'
        b=[]                  # 'b' is a•{02} in GF(2^8)
        0.upto(3) do |i|
          a[i] = state[i][c]
          b[i] = (state[i][c] & 0x80 == 0) ? (state[i][c] << 1) ^ 0x011b : state[i][c] << 1
        end
        # a[n] ^ b[n] is a•{03} in GF(2^8)
        state[0][c] = b[0] ^ a[1] ^ b[1] ^ a[2] ^ a[3]        # 2*a0 + 3*a1 + a2 + a3
        state[1][c] = a[0] ^ b[1] ^ a[2] ^ b[2] ^ a[3]        # a0 * 2*a1 + 3*a2 + a3
        state[2][c] = a[0] ^ a[1] ^ b[2] ^ a[3] ^ b[3]        # a0 + a1 + 2*a2 + 3*a3
        state[3][c] = a[0] ^ b[0] ^ a[1] ^ a[2] ^ b[3]        # 3*a0 + a1 + a2 + 2*a3
      end
      state
    end

    # xor Round Key into state S
    def self.add_round_key(state, w, rnd)
      0.upto(3) do |r|
        0.upto(CIPHER_BLOCK_SIZE - 1) { |c| state[r][c] ^= w[rnd * 4 + c][r] }
      end
      state
    end

    # apply SBox to 4-byte word w
    def self.sub_word(word)
      0.upto(3){ |i| word[i] = S_BOX[word[i]] }
      word
    end

    # rotate 4-byte word w left by one byte
    def self.rotate_word(word)
      tmp = word[0]
      0.upto(2){ |i| word[i] = word[i + 1] }
      word[3] = tmp
      word
    end
end



class AesCtr

  #  Encrypt a text using AES encryption in Counter mode of operation
  #
  #  Unicode multi-byte character safe
  #
  #  @param string plaintext Source text to be encrypted
  #  @param string password  The password to use to generate a key
  #  @param int num_bits     Number of bits to be used in the key (128, 192, or 256)
  #  @returns string         Encrypted text
  def self.encrypt(plaintext, password, num_bits)
    block_size = 16      # block size fixed at 16 bytes / 128 bits (Nb=4) for AES
    return '' unless num_bits==128

    # use AES itself to encrypt password to get cipher key (using plain password as source for key
    # expansion) - gives us well encrypted key (though hashed key might be preferred for prod'n use)
    num_bytes = num_bits / 8        # no bytes in key (16/24/32)
    pw_bytes = []
    0.upto(num_bytes - 1){ |i| pw_bytes[i] = password.bytes.to_a[i] & 0xff || 0}      # use 1st 16/24/32 chars of password for key #warn
    key = Aes.cipher(pw_bytes, Aes.key_expansion(pw_bytes))        # gives us 16-byte key
    key = key + key[0, num_bytes - 16]                             # expand key to 16/24/32 bytes long

    # initialise 1st 8 bytes of counter block with nonce (NIST SP800-38A §B.2): [0-1] = millisec,
    # [2-3] = random, [4-7] = seconds, together giving full sub-millisec uniqueness up to Feb 2106
    counter_block = []
    nonce = Time.now.to_i
    nonce_ms = nonce % 1000
    nonce_sec = (nonce / 1000.0).floor
    nonce_rand = (rand() * 0xffff).floor
    0.upto(1){ |i| counter_block[i] = urs(nonce_ms, i * 8) & 0xff }
    0.upto(1){ |i| counter_block[i + 2] = urs(nonce_rand, i * 8) & 0xff }
    0.upto(3){ |i| counter_block[i + 4] = urs(nonce_sec, i * 8) & 0xff }

    # and convert it to a string to go on the front of the ciphertext
    ctr_text = ''
    0.upto(7){ |i| ctr_text += counter_block[i].chr }

    # generate key schedule - an expansion of the key into distinct Key Rounds for each round
    key_schedule = Aes.key_expansion(key)
    block_count = (plaintext.length / block_size.to_f).ceil

    cipher_text = []
    0.upto(block_count - 1) do |b|
      # set counter (block #) in last 8 bytes of counter block (leaving nonce in 1st 8 bytes)
      # done in two stages for 32-bit ops: using two words allows us to go past 2^32 blocks (68GB)
      0.upto(3){ |c| counter_block[15 - c] = urs(b, c * 8) & 0xff }
      0.upto(3){ |c| counter_block[15 - c - 4] = urs(b / 0x100000000, c * 8) }

      cipher_cntr = Aes.cipher(counter_block, key_schedule) # -- encrypt counter block --
      # block size is reduced on final block
      block_length =  b < block_count - 1 ? block_size : (plaintext.length - 1) % block_size + 1
      cipher_char = []
      0.upto(block_length - 1) do |i|
        cipher_char[i] = (cipher_cntr[i] ^ plaintext.bytes.to_a[b * block_size + i]).chr
      end
      cipher_text[b] = cipher_char.join
    end

    cipher_text = ctr_text + cipher_text.join
    cipher_text = Base64.encode64(cipher_text).gsub(/\n/, '') + "\n";  # encode in base64
  end

  # Decrypt a text encrypted by AES in counter mode of operation
  #
  # @param string ciphertext Source text to be encrypted
  # @param string password   The password to use to generate a key
  # @param int nBits      Number of bits to be used in the key (128, 192, or 256)
  # @returns string
  #           Decrypted text
  def self.decrypt(ciphertext, password, nBits)
    blockSize = 16  # block size fixed at 16 bytes / 128 bits (Nb=4) for AES
    return '' unless(nBits==128 || nBits==192 || nBits==256)
    ciphertext = Base64.decode64(ciphertext);

    nBytes = nBits/8  # no bytes in key (16/24/32)
    pwBytes = []
    0.upto(nBytes-1){|i| pwBytes[i] = password.bytes.to_a[i] & 0xff || 0}
    key = Aes.cipher(pwBytes, Aes.key_expansion(pwBytes)) # gives us 16-byte key
    key = key.concat(key.slice(0, nBytes-16)) # expand key to 16/24/32 bytes long
    # recover nonce from 1st 8 bytes of ciphertext
    counterBlock = []
    ctrTxt = ciphertext[0,8]
    0.upto(7){|i| counterBlock[i] = ctrTxt.bytes.to_a[i]}

    #generate key Schedule
    keySchedule = Aes.key_expansion(key);

    # separate ciphertext into blocks (skipping past initial 8 bytes)
    nBlocks = ((ciphertext.length-8)/blockSize.to_f).ceil
    ct=[]
    0.upto(nBlocks-1){|b|ct[b] = ciphertext[8+b*blockSize, 16]}

    ciphertext = ct;  # ciphertext is now array of block-length strings

    # plaintext will get generated block-by-block into array of block-length strings
    plaintxt = [];
    0.upto(nBlocks-1) do |b|
      0.upto(3){|c| counterBlock[15-c] = urs(b,c*8) & 0xff}
      0.upto(3){|c| counterBlock[15-c-4] = urs((b+1)/(0x100000000-1),c*8) & 0xff}
      cipherCntr = Aes.cipher(counterBlock, keySchedule)  # encrypt counter block
      plaintxtByte = []
      0.upto(ciphertext[b].length - 1) do |i|
        # -- xor plaintxt with ciphered counter byte-by-byte --
        plaintxtByte[i] = (cipherCntr[i] ^ ciphertext[b].bytes.to_a[i]).chr;
      end
      plaintxt[b] = plaintxtByte.join('')
    end
    plaintext = plaintxt.join('')
  end

  private

  # Unsigned right shift function, since Ruby has neither >>> operator nor unsigned ints
  #
  # @param a  number to be shifted (32-bit integer)
  # @param b  number of bits to shift a to the right (0..31)
  # @return   a right-shifted and zero-filled by b bits
  def self.urs(a, b)
    a &= 0xffffffff
    b &= 0x1f
    if a & 0x80000000 && b > 0    # if left-most bit set
      a = ((a >> 1) & 0x7fffffff) # right-shift one bit & clear left-most bit
      a = a >> (b - 1)            # remaining right-shifts
    else                     # otherwise
      a = (a >> b);            # use normal right-shift
    end
    a
  end
end